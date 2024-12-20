extends Node

var inventory = []
var hotbar = []
@export var inventory_slots = 15
@export var hotbar_slots = 5


signal inventory_updated
signal hotbar_updated

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
			return true
	return false

func remove_item(index):
	inventory[index] = null

#func increase_inventory():
#	inventory_updated.emit()

func set_player(player):
	player_node = player

func move_item_hotbar(item, new_slot: int) -> bool:

	if hotbar[new_slot] == item:
		hotbar[new_slot] = null # Remove o item, desequipando-o
		hotbar_updated.emit()
		return true

	# Primeiro, remove o item da posição anterior na hotbar, se ele estiver presente
	for i in range(hotbar.size()):
		if hotbar[i] == item:
			hotbar[i] = null # Remove o item da posição anterior
			break

	# Verifica se o item já está em qualquer outro slot da hotbar para evitar duplicação
	for i in range(hotbar.size()):
		if hotbar[i] == item:
			return false

	# Adiciona o item na nova posição da hotbar
	if hotbar[new_slot] == null or hotbar[new_slot] != item:
		hotbar[new_slot] = item
		hotbar_updated.emit()
		return true
	
	return false
