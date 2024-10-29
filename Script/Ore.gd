extends StaticBody3D

@export var life := 5

@rpc("any_peer","call_local")
func mine():
	if life <= 0:
		queue_free()
	life -= 1 
