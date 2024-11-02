extends Control

@onready var item_image: Sprite2D = $OuterBorder/InnerBorder/ItemImage
@onready var item_quantity: Label = $OuterBorder/InnerBorder/ItemQuantity
@onready var item_name: Label = $DetailsPanel/VSplitContainer/ItemName
@onready var item_type: Label = $DetailsPanel/VSplitContainer/ItemType
@onready var item_effect: Label = $DetailsPanel/VSplitContainer/ItemEffect
@onready var use_panel: Panel = $UsePanel
@onready var details_panel: Panel = $DetailsPanel
@onready var button: Button = $Button

var item = null

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_tab"):
		use_panel.hide()
		details_panel.hide()

func _on_button_mouse_entered() -> void:
	if item != null:
		use_panel.hide()
		details_panel.show()

func _on_button_mouse_exited() -> void:
	details_panel.hide()

func _on_button_pressed() -> void:
	if item != null:
		details_panel.visible = !details_panel.visible
		use_panel.visible = !use_panel.visible

func set_empty():
	item_image.texture = null
	item_quantity.text = ""

func set_item(new_item):
	item = new_item
	item_image.texture = item["texture"]
	item_quantity.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str(item["effect"])
	else:
		item_effect.text = ""
