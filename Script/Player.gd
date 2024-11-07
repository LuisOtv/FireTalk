extends CharacterBody3D

@export var camera: Camera3D
@export var anim_player: AnimationPlayer
@export var body: MeshInstance3D
@export var backpack: Control

@export var GRAVITY_MULTIPLIER := 1.0
@export var SPEED := 2.0
@export var JUMP_VELOCITY := 4.5
@export var ROTATION_SPEED := 12

@onready var walking_particles: GPUParticles3D = $GPUParticles3D
@onready var interact_ui: CanvasLayer = $Interface/InteractUI
@onready var inventory_ui: CanvasLayer = $Interface/BackpackUI
@onready var hotbar_ui: CanvasLayer = $Interface/HotbarUI
@onready var nametag: Label = $Nametag/SubViewport/Label
@onready var chat: CanvasLayer = get_tree().get_nodes_in_group("ChatController")[0]
@onready var transition: ColorRect = get_tree().get_nodes_in_group("Transition")[0]

var usrnm := "Default"
var nearby_objects = []

var isOnMenu := false
var isOnNPC := false
var obj

signal backpack_change_state

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready():
	InventoryController.set_player(self)

	camera.current = is_multiplayer_authority()
	usrnm = PlayerInfo.usrnm
	nametag.text = usrnm

	if is_multiplayer_authority():
		backpack.animation_player.play("close")
		chat.show()
		inventory_ui.show()

func _physics_process(delta: float) -> void:
	
	if not is_multiplayer_authority(): return
	if chat.get_node("Message").has_focus(): return
	
	apply_gravity(delta)
	handle_movement(delta)

	move_and_slide()

func _input(event) -> void:
	handle_interaction(event)

func apply_gravity(delta):

	if not is_on_floor():
		velocity += (get_gravity() * GRAVITY_MULTIPLIER) * delta

func handle_movement(delta: float) -> void:
	
	if isOnMenu or isOnNPC: 
		anim_player.play('Idle') 
		return
	
	# JUMP
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# GET IMPUT DIRECTION
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# CONVERT DIRECTION BASED ON CAMERA
	var forward_dir = camera.global_transform.basis.z
	var right_dir = camera.global_transform.basis.x

	# IGNORE Y COMPONENT
	forward_dir.y = 0
	right_dir.y = 0
	forward_dir = forward_dir.normalized()
	right_dir = right_dir.normalized()

	var direction := (forward_dir * input_dir.y + right_dir * input_dir.x).normalized()
	
	# WALKING
	if direction:
		if is_on_floor():
			walking_particles.emitting = true

		anim_player.play('Walking')
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		# CALCULATE ROTATION
		var target_rotation = direction.angle_to(Vector3.FORWARD)

		# MATH
		var cross_product = Vector3.FORWARD.cross(direction).y
		if cross_product > 0:
			target_rotation = -target_rotation

		var current_rotation = body.rotation.y

		# ROTATES TOWARDS TARGET
		body.rotation.y = lerp_angle(current_rotation, -target_rotation, ROTATION_SPEED * delta)
	
	# NOT WALKING
	else:
		walking_particles.emitting = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		anim_player.play('Idle')

func handle_interaction(event):
	if event.is_action_pressed("ui_e") and is_on_floor():
		if nearby_objects.size() > 0:
			var object = nearby_objects[0]

			if object.is_in_group("Item"):
				object.interact()
				nearby_objects.remove_at(0)

			elif object.is_in_group("Teleport"):
				transition.animation_player.play("FadeIn")
				await transition.animation_player.animation_finished
				object.interact(self)
			
			elif object.is_in_group("NPC"):
				isOnNPC = !isOnNPC
				object.interact()

			if nearby_objects.size() == 0:
				interact_ui.hide()

	if Input.is_action_just_pressed("ui_tab"):
		if backpack.animation_player.is_playing(): return
		chat.visible = !chat.visible
		isOnMenu = !isOnMenu
		backpack_change_state.emit()

func _on_area_3d_area_entered(area: Area3D) -> void:

	obj = area.get_parent()

	if obj.is_in_group("Interactable"):
		if not nearby_objects.has(obj):
			nearby_objects.append(obj)

		if is_multiplayer_authority():
			interact_ui.show()

func _on_area_3d_area_exited(area: Area3D) -> void:

	obj = area.get_parent()
	nearby_objects.erase(obj)
	
	if is_multiplayer_authority() and nearby_objects.size() == 0:
		interact_ui.hide()
