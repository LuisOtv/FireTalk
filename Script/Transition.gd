extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func fade_out():
	animation_player.play("FadeOut")
