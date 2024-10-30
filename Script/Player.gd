extends CharacterBody3D

@export var camera: Camera3D
@export var anim_player: AnimationPlayer
@export var body: MeshInstance3D

@export var GRAVITY_MULTIPLIER := 1.0
@export var SPEED := 2.0
@export var JUMP_VELOCITY := 4.5
@export var ROTATION_SPEED := 12

@onready var username_line: LineEdit = $Interface/Username/Panel/PanelContainer/MarginContainer/VBoxContainer/Username
@onready var username: CanvasLayer = $Interface/Username
@onready var Chat: CanvasLayer = get_tree().get_nodes_in_group("ChatController")[0]
@onready var mining_minigame: Node2D = $MiningMinigame
@onready var money_counter: Label = $Interface/HUD/money_counter
@onready var respawn: Marker3D = $Respawn

var usrnm : String
var setted := false
var mining = false
var mine = false

var money = 0

var distance_threshold = 1.5  # Distância máxima
var nearby_ores = []  # Para armazenar objetos que estão dentro da distância

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready():
	camera.current = is_multiplayer_authority()
	mining_minigame.hide()
	
	if is_multiplayer_authority():
		# Exibe a interface de username apenas para o jogador local
		username.show()
	else:
		# Oculta a interface de username para outros jogadores
		username.hide()

func _physics_process(delta: float) -> void:

	if not is_multiplayer_authority(): return
	if not setted: return
	if mining: return
	if Chat.get_node("Message").has_focus(): return
	
	var Ores = get_tree().get_nodes_in_group("Ore")
	
	money_counter.text = str(PlayerInfo.money)

	# Add gravity
	if not is_on_floor():
		velocity += (get_gravity() * GRAVITY_MULTIPLIER) * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_e") and is_on_floor():
		if mine:
			var ore = nearby_ores[0]
			$MiningMinigame.ore = ore
			$MiningMinigame.timermexernissodps = 10
			mining = true
			mining_minigame.show()

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
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		anim_player.play('Idle')
	
	move_and_slide()
	check_nearby_objects()  # Chame a função a cada frame

# Função para checar objetos próximos
func check_nearby_objects():
	
	nearby_ores.clear()  # Limpa o array antes de verificar novamente
	# Obtém todos os nós do grupo "enemies"
	var ores = get_tree().get_nodes_in_group("Ore")
	# Verifica a distância de cada inimigo em relação ao jogador
	for ore in ores:
		if ore.position.distance_to(self.position) <= distance_threshold:
			nearby_ores.append(ore)
	# Se existirem objetos próximos, faça algo
	if nearby_ores.size() > 0:
		mine = true
	else:
		mine = false

func _on_ok_pressed() -> void:
	if username_line.text != "":
		setted = true
		usrnm = username_line.text
		PlayerInfo.usrnm = usrnm
		Chat.show()
		$Interface/Username.hide()
		$Nametag/SubViewport/Label.text = usrnm
