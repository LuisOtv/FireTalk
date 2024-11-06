extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func fade_out(delta: float) -> void:
	animation_player.play("FadeOut")
