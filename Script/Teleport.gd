extends StaticBody3D

@export var target : Marker3D
# Called when the node enters the scene tree for the first time.
func interact(player) -> void:
	player.global_transform.origin = target.global_transform.origin
