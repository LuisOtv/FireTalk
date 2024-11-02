extends Area3D

@export var respawn_point: Marker3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area3D) -> void:
	var player = area.get_parent()

	if player.is_in_group("Player"):
		player.global_transform.origin = respawn_point.global_transform.origin
