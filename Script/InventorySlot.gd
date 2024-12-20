extends Control

@export var item_image: Sprite2D 
@export var item_quantity: Label
@export var item_name: Label
@export var item_type: Label
@export var item_effect: Label
@export var details_panel: Panel

var index = 0
var item = null
var selected = false

func _input(event: InputEvent) -> void:

	# OPEN BACKPACK
	if event.is_action_pressed("ui_tab"):
		details_panel.hide()

	# DROP ITEM
	if event.is_action_pressed("ui_q") and selected:
		details_panel.hide()
		InventoryController.remove_item(index)
		set_empty()

	# SEND ITEM TO HOTBAR
	if selected:
		if event.is_action_pressed("ui_1"):
			InventoryController.move_item_hotbar(item, 0)
		elif event.is_action_pressed("ui_2"):
			InventoryController.move_item_hotbar(item, 1)
		elif event.is_action_pressed("ui_3"):
			InventoryController.move_item_hotbar(item, 2)
		elif event.is_action_pressed("ui_4"):
			InventoryController.move_item_hotbar(item, 3)
		elif event.is_action_pressed("ui_5"):
			InventoryController.move_item_hotbar(item, 4)

func _on_button_mouse_entered() -> void:
	if item != null:
		selected = true
		details_panel.show()

func _on_button_mouse_exited() -> void:
	details_panel.hide()
	selected = false

func set_empty():
	item = null
	item_image.texture = null
	item_quantity.text = ""

func set_item(new_item):
	item = new_item
	item_image.texture = item["texture"]
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str(item["effect"])
	else:
		item_effect.text = ""
