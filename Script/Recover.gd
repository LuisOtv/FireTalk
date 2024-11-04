extends Area3D

@export var respawn_point: Marker3D

func _on_area_entered(area: Area3D) -> void:
	var player = area.get_parent()

	if player.is_in_group("Player"):
		player.global_transform.origin = respawn_point.global_transform.origin
