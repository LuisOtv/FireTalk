extends CharacterBody3D

@export var camera: Camera3D
@export var anim_player: AnimationPlayer
@export var body: MeshInstance3D

@export var GRAVITY_MULTIPLIER := 1.0
@export var SPEED := 2.0
@export var JUMP_VELOCITY := 4.5
@export var ROTATION_SPEED := 12

@onready var walking_particles: GPUParticles3D = $GPUParticles3D
@onready var interact_ui: CanvasLayer = $Interface/InteractUI
@onready var inventory_ui: CanvasLayer = $Interface/InventoryUI
@onready var chat: CanvasLayer = get_tree().get_nodes_in_group("ChatController")[0]
@onready var nametag: Label = $Nametag/SubViewport/Label

var object
var usrnm : String
var setted := false

var money = 0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready():
	InventoryController.set_player(self)
	camera.current = is_multiplayer_authority()
	
	usrnm = PlayerInfo.usrnm
	nametag.text = usrnm
	chat.show()

func _physics_process(delta: float) -> void:
	
	if not is_multiplayer_authority(): return
	
	can_walk()

	var Ores = get_tree().get_nodes_in_group("Ore")

	# Add gravity
	if not is_on_floor():
		velocity += (get_gravity() * GRAVITY_MULTIPLIER) * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_e") and is_on_floor():
		if object != null:
			object.interact()
	
	if Input.is_action_just_pressed("ui_tab"):
		inventory_ui.visible = !inventory_ui.visible
		chat.visible = !chat.visible

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
	object = area.get_parent()
	if object.is_in_group("Interactable"):
		if is_multiplayer_authority():
			interact_ui.show()

func _on_area_3d_area_exited(area: Area3D) -> void:
	object = null
	if is_multiplayer_authority():
		interact_ui.hide()
	
func can_walk():
	if chat.get_node("Message").has_focus(): return
