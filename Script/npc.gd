extends Node3D

@export var camera_pos: Marker3D
@export var npc_ui: CanvasLayer

var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func interact():
	npc_ui.visible = !npc_ui.visible
