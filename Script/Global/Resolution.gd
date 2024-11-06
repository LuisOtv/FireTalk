extends Node

func _ready() -> void:
	pass
	get_viewport().size =  DisplayServer.screen_get_size()
	# get_viewport().size =  Vector2(1280,720)
