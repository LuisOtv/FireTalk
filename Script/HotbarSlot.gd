extends Control

@export var item_image: Sprite2D 
@export var label: Label

var item = null
var index = 0
var selected = false

func _on_button_mouse_entered() -> void:
	if item != null:
		selected = true

func _on_button_mouse_exited() -> void:
	selected = false

func set_empty():
	item = null
	item_image.texture = null
	label.text = str(index + 1)

func set_item(new_item):
	item = new_item
	item_image.texture = item["texture"]
	label.text = str(index + 1)
