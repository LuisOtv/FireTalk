extends Node2D

@onready var right: Marker2D = $"PanelContainer/Right"
@onready var left: Marker2D = $"PanelContainer/Left"
@onready var middle: Marker2D = $"PanelContainer/Middle"
@onready var bar: Sprite2D = $Sprite2D
@export var player: CharacterBody3D

var timermexernissodps = 10
var ore: StaticBody3D

# Variável para controlar a direção (1 para direita, -1 para esquerda)
var direction: int = -1
# Velocidade do movimento
@export var speed: float = 100.0

func _ready() -> void:
	global_position.x = get_viewport_rect().size.x /2

func _process(delta: float) -> void:
	if not player.mining: return
	timermexernissodps -= 1
	# Move o sprite com base na direção e velocidade
	bar.global_position.x += direction * speed * delta
	
	# Verifica se o sprite chegou ao limite esquerdo ou direito da tela
	if bar.global_position.x <= left.global_position.x:
		direction = 1  # Muda para a direita
	elif bar.global_position.x >= right.global_position.x:
		direction = -1  # Muda para a esquerda
	
	if Input.is_action_just_pressed("ui_e"):
		if timermexernissodps <= 0:
			player.mining = false
			ore.rpc("mine")
			hide()
		
