extends Control

@export var grid_container: GridContainer
@export var inventory: Control
@export var customization: Control
@export var extra: Control
@export var settings: Control
@export var animation_player: AnimationPlayer

var opened := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryController.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()

func _on_inventory_updated():
	clear_grid_container()
	
	for item in InventoryController.inventory:
		var slot = InventoryController.inventory_slot_scene.instantiate()
		slot.index = grid_container.get_child_count()
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
	settings.hide()
	animation_player.play("swap")

func _on_customization_pressed() -> void:
	inventory.hide()
	customization.show()
	extra.hide()
	settings.hide()
	animation_player.play("swap")
	
func _on_extra_pressed() -> void:
	inventory.hide()
	customization.hide()
	extra.show()
	settings.hide()
	animation_player.play("swap")


func _on_settings_pressed() -> void:
	inventory.hide()
	customization.hide()
	extra.hide()
	settings.show()
	animation_player.play("swap")

func open():
	inventory.show()
	customization.hide()
	extra.hide()
	settings.hide()
	animation_player.play("open")

func _on_player_backpack_change_state() -> void:
	if opened:
		animation_player.play("close")
	else:
		open()
	opened = !opened

func _on_exit_pressed() -> void:
	get_tree().quit()
