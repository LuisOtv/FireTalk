extends StaticBody3D

@export var life := 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@rpc("any_peer","call_local")
func mine():
	if life <= 0:
		queue_free()
	life -= 1 
