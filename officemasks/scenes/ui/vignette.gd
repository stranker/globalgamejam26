extends ColorRect
class_name Vignette

@onready var anim: AnimationPlayer = $Anim

signal end_fade_in()
signal end_fade_out()

func fade_in():
	anim.play("fade_in")
	await anim.animation_finished
	end_fade_in.emit()
	pass

func fade_out():
	anim.play_backwards("fade_in")
	await anim.animation_finished
	end_fade_out.emit()
	pass
