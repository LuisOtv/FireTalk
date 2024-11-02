extends Control

@onready var grid_container: GridContainer = $Panel/MarginContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryController.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
