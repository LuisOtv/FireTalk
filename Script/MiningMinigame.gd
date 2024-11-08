extends Control

@export var arrow: Sprite2D
@export var bar: Sprite2D
@export var hit_point: Marker2D
@export var initial_point: Marker2D
@export var animation_player: AnimationPlayer

var spd : float = 0.2
var dificulty = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_e"):
		var diference = arrow.position.x - hit_point.position.x
		if diference > -50 and diference < 50:
			hit()
		else:
			miss()

func start():
	animation_player.speed_scale = spd
	arrow.position = initial_point.position
	spd += 0.2
	animation_player.play("go")
	
func stop():
	arrow.position = initial_point.position
	spd = 0

func hit():
	dificulty -= 1
	if dificulty > 0:
		start()
	else:
		miss()
		print("win")
	
func miss():
	arrow.position = initial_point.position
	stop()
