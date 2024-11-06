extends RigidBody3D

@onready var icon_sprite = $Sprite2D

@export var item_name = ""
@export var item_type = ""
@export var item_effect = ""
@export var item_mesh: MeshInstance3D
@export var item_texture: Texture

var scene_path: String = "res://Inventory/InventoryItem.tscn"

# Called when the node enters the scene tree for the first time.

@rpc("any_peer","call_local")
func interact():
	var item = {
		"texture" : item_texture,
		"name" : item_name,
		"type" : item_type,
		"effect" : item_effect,
		"scene_path" : scene_path,
	}
	if InventoryController.player_node:
		InventoryController.add_item(item)
		rpc("destroy_object")

# No script do objeto
@rpc("any_peer","call_local")
func destroy_object():
	self.queue_free()
