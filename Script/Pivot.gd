extends Node3D

@export var Camera_Look : Marker3D
@export var Camera : Camera3D
@export var Spring : SpringArm3D

var rotation_speed := 0.00001  # Sensibilidade da rotação
var max_vertical_angle := deg_to_rad(80)  # Limite para rotação vertical
var is_rotating := false  # Para verificar se estamos rotacionando

func _ready():
	# Inicialmente, o cursor do mouse será visível
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	# Detecta se o botão direito foi pressionado
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				is_rotating = true  # Começar a rotação
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Capturar o cursor do mouse
			else:
				is_rotating = false  # Parar a rotação
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Liberar o cursor do mouse

		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			Spring.spring_length += 0.2
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			Spring.spring_length -= 0.2

func _process(delta: float) -> void:
	if is_rotating:
		var mouse_delta = Input.get_last_mouse_velocity()  # Pega a diferença de movimento do mouse

		# Rotaciona o pivô horizontal (eixo Y) com base no movimento horizontal do mouse
		rotate_y(-mouse_delta.x * rotation_speed)

		# Rotaciona o pivô vertical (eixo X) com base no movimento vertical do mouse
		rotate_vertical(-mouse_delta.y * rotation_speed)
	
	# Faz a câmera sempre olhar para o Player
	Camera.look_at(Camera_Look.global_transform.origin)

# Função para rotacionar no eixo X com limites
func rotate_vertical(amount: float) -> void:
	var pivot_vertical = $PivotVertical
	var new_rotation_x = pivot_vertical.rotation.x + amount
	
	# Limita a rotação vertical entre -80 e 80 graus
	new_rotation_x = clamp(new_rotation_x, -max_vertical_angle, max_vertical_angle)
	pivot_vertical.rotation.x = new_rotation_x
