extends ColorRect
class_name Vignette

@onready var anim: AnimationPlayer = $Anim

signal end_fade_in()
signal end_fade_out()

func total_black():
	anim.play("total_black")
	pass

func fade_in():
	anim.speed_scale = 1
	anim.play("fade_in")
	await anim.animation_finished
	end_fade_in.emit()
	pass

func fade_out():
	anim.play_backwards("fade_in")
	await anim.animation_finished
	end_fade_out.emit()
	pass

func slow_fade_in():
	anim.speed_scale = 0.1
	anim.play("fade_in")
	await anim.animation_finished
	end_fade_in.emit()
	pass

func slow_fade_out():
	anim.speed_scale = 0.1
	anim.play_backwards("fade_in")
	await anim.animation_finished
	end_fade_out.emit()
	pass
