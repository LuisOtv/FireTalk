extends Control

@onready var all: CanvasLayer = $OuterBorder/InnerBorder/All
@onready var grid_container: GridContainer = $OuterBorder/InnerBorder/Inventory/GridContainer
@onready var inventory: Control = $OuterBorder/InnerBorder/Inventory
@onready var extra: CanvasLayer = $OuterBorder/InnerBorder/Extra
@onready var customization: CanvasLayer = $OuterBorder/InnerBorder/Customization
@export var player: CharacterBody3D
@export var animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryController.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

func _process(delta: float) -> void:
	if !player.isOnMenu:
		inventory.hide()
		customization.hide()
		extra.hide()

func _on_inventory_updated():
	clear_grid_container()
	
	for item in InventoryController.inventory:
		var slot = InventoryController.inventory_slot_scene.instantiate()
		grid_container.add_child(slot)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()

func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()

func _on_inventory_pressed() -> void:
	inventory.show()
	customization.hide()
	extra.hide()
	animation_player.play("swap")

func _on_customization_pressed() -> void:
	inventory.hide()
	customization.show()
	extra.hide()
	animation_player.play("swap")
	
func _on_extra_pressed() -> void:
	inventory.hide()
	customization.hide()
	extra.show()
	animation_player.play("swap")

func open():
	inventory.show()
	customization.hide()
	extra.hide()
	animation_player.play("open")
