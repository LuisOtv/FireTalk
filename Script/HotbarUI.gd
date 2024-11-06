extends Control

@export var container: HBoxContainer

var opened := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryController.hotbar_updated.connect(_on_hotbar_updated)
	_on_hotbar_updated()

func _on_hotbar_updated():
	clear_grid_container()
	
	for item in InventoryController.hotbar:
		var slot = InventoryController.hotbar_slot_scene.instantiate()
		slot.index = container.get_child_count()
		container.add_child(slot)
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()

func clear_grid_container():
	while container.get_child_count() > 0:
		var child = container.get_child(0)
		container.remove_child(child)
		child.queue_free()
