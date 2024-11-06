extends Node

var inventory = []
var hotbar = []
@export var inventory_slots = 15
@export var hotbar_slots = 5


signal inventory_updated

var player_node: Node = null
@onready var inventory_slot_scene = preload("res://Inventory/InventorySlot.tscn")
@onready var hotbar_slot_scene = preload("res://Inventory/HotbarSlot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.resize(inventory_slots)
	hotbar.resize(hotbar_slots)

func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			print(inventory)
			return true
	return false

func remove_item(index):
	inventory[index] = null

#func increase_inventory():
#	inventory_updated.emit()

func set_player(player):
	player_node = player

func add_item_hotbar(item,i):
	if hotbar[i] == null:
		hotbar[i] = item
		inventory_updated.emit()
		print(hotbar)
		return true
	return false

func remove_item_hotbar(item_type,item_effect):
	for i in range(hotbar.size()):
		if hotbar[i] != null and hotbar[i]["type"] == item_type and hotbar[i]["effect"] == item_effect:
			hotbar[i] = null
			inventory_updated.emit()
			return true
	return false

func unassign_item_hotbar(item_type,item_effect):
	for i in range(hotbar.size()):
		if hotbar[i] != null and hotbar[i]["type"] == item_type and hotbar[i]["effect"] == item_effect:
			hotbar[i] = null
			inventory_updated.emit()
			return true
	return false
	
func assign_item_hotbar(item_type,item_effect):
	for i in range(hotbar.size()):
		if hotbar[i] != null and hotbar[i]["type"] == item_type and hotbar[i]["effect"] == item_effect:
			hotbar[i] = null
			inventory_updated.emit()
			return true
	return false
