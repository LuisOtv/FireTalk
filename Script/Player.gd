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

var nearby_objects = []
var usrnm := ""
var setted := false
var isOnMenu := false

var money = 0

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

	# Add gravity
	if not is_on_floor():
		velocity += (get_gravity() * GRAVITY_MULTIPLIER) * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle interaction with nearby objects
	if Input.is_action_just_pressed("ui_e") and is_on_floor():
		if nearby_objects.size() > 0:
			var object = nearby_objects[0]
			if object.is_in_group("Item"):
				object.interact()
			elif object.is_in_group("Teleport"):
				transition.animation_player.play("FadeIn")
				await transition.animation_player.animation_finished
				object.interact(self)
			nearby_objects.remove_at(0)  # Remove o objeto interagido da lista
			if nearby_objects.size() == 0:
				interact_ui.hide()

	if Input.is_action_just_pressed("ui_tab"):
		if backpack.animation_player.is_playing(): return
		chat.visible = !chat.visible
		isOnMenu = !isOnMenu
		backpack_change_state.emit()
	
	# Get the input direction and handle the movement/deceleration
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Convert input direction to world direction aligned with camera
	var forward_dir = camera.global_transform.basis.z
	var right_dir = camera.global_transform.basis.x

	# Ignore Y component of camera directions for XZ movement
	forward_dir.y = 0
	right_dir.y = 0
	forward_dir = forward_dir.normalized()
	right_dir = right_dir.normalized()

	var direction := (forward_dir * input_dir.y + right_dir * input_dir.x).normalized()

	if direction:
		if is_on_floor():
			walking_particles.emitting = true
		anim_player.play('Walking')
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		# Calculate desired rotation based on movement direction
		var target_rotation = direction.angle_to(Vector3.FORWARD)
				
		# Use cross product to determine if character should rotate left or right
		var cross_product = Vector3.FORWARD.cross(direction).y
		if cross_product > 0:
			target_rotation = -target_rotation

		var current_rotation = body.rotation.y

		# Smoothly rotate the body towards the target
		body.rotation.y = lerp_angle(current_rotation, -target_rotation, ROTATION_SPEED * delta)
	else:
		walking_particles.emitting = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		anim_player.play('Idle')
	
	move_and_slide()

func _on_area_3d_area_entered(area: Area3D) -> void:
	var obj = area.get_parent()
	if obj.is_in_group("Interactable"):
		if not nearby_objects.has(obj):
			nearby_objects.append(obj)
		if is_multiplayer_authority():
			interact_ui.show()

func _on_area_3d_area_exited(area: Area3D) -> void:
	var obj = area.get_parent()
	nearby_objects.erase(obj)
	if is_multiplayer_authority() and nearby_objects.size() == 0:
		interact_ui.hide()
