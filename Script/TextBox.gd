extends Control

@export var label: RichTextLabel

var type_writter = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.visible_ratio = type_writter

func _on_timer_timeout() -> void:
	type_writter += 0.1

func _on_npc_update_text() -> void:
	type_writter = 0
