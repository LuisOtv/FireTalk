extends Node

var inventory = []
@export var slots = 6

signal inventory_updated

var player_node: Node = null
@onready var inventory_slot_scene = preload("res://Inventory/InventorySlot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.resize(slots)

func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			print(inventory)
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			print(inventory)
			return true
		return false

func remove_item():
	inventory_updated.emit()

func increase_inventory():
	inventory_updated.emit()

func set_player(player):
	player_node = player
