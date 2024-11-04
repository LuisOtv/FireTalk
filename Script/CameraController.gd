extends Node3D

@export var camera : Camera3D
@export var spring : SpringArm3D
@export var camera_look : Marker3D
@export var camera_normal : Marker3D
@export var camera_menu : Marker3D
@export var player : CharacterBody3D

var rotation_speed := 0.00001
var max_vertical_angle := deg_to_rad(80)  
var is_rotating := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				is_rotating = true  
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  
			else:
				is_rotating = false  
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 

		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			spring.spring_length += 0.2
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			spring.spring_length -= 0.2

func _process(delta: float) -> void:
	
	spring.spring_length = clamp(spring.spring_length, 3, 10)
	
	if is_rotating:
		var mouse_delta = Input.get_last_mouse_velocity()  

		rotate_y(-mouse_delta.x * rotation_speed)
		rotate_vertical(-mouse_delta.y * rotation_speed)

	if player.isOnMenu:
		camera.global_transform.basis = lerp(camera.global_transform.basis,camera_menu.global_transform.basis,0.2)
		camera.global_transform.origin = lerp(camera.global_transform.origin,camera_menu.global_transform.origin,0.2)
	else:
		camera.look_at(camera_look.global_transform.origin)
		camera.global_transform.origin = lerp(camera.global_transform.origin, camera_normal.global_transform.origin,0.2)

func rotate_vertical(amount: float) -> void:
	var pivot_vertical = $PivotVertical
	var new_rotation_x = pivot_vertical.rotation.x + amount
	
	new_rotation_x = clamp(new_rotation_x, -max_vertical_angle, max_vertical_angle)
	pivot_vertical.rotation.x = new_rotation_x
