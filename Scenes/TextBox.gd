extends Control

var type_writter = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	$Panel/Label.visible_ratio = type_writter

func _on_timer_timeout() -> void:
	type_writter += 0.05
