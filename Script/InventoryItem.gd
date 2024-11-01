extends RigidBody3D

@onready var icon_sprite = $Sprite2D

@export var item_name = ""
@export var item_type = ""
@export var item_effect = ""
@export var item_mesh: MeshInstance3D
@export var item_texture: Texture

var scene_path: String = "res://Inventory/InventoryItem.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var player_in_range = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if player_in_range and Input.is_action_just_pressed("ui_e"):
		pickup_item()

@rpc("any_peer","call_local")
func pickup_item():
	var item = {
		"quantity" : 1,
		"texture" : item_texture,
		"name" : item_name,
		"type" : item_type,
		"effect" : item_effect,
		"scene_path" : scene_path,
	}
	if InventoryController.player_node:
		InventoryController.add_item(item)
		rpc("destroy_object")

func _on_area_3d_area_entered(area: Area3D) -> void:
	var player = area.get_parent()
	
	if player.is_in_group("Player"):
		player.interact_ui.show()
		player_in_range = true

func _on_area_3d_area_exited(area: Area3D) -> void:
	var player = area.get_parent()
	
	if player.is_in_group("Player"):
		player.interact_ui.hide()
		player_in_range = false

# No script do objeto
@rpc("any_peer","call_local")
func destroy_object():
	self.queue_free()
