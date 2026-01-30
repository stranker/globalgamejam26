extends Camera2D

@export var notepad_x_offset: float

func on_notepad_open():
	var tween: Tween = create_tween()
	tween.tween_property(self, "offset", Vector2(notepad_x_offset, 0), 0.2).set_ease(Tween.EASE_IN)
	tween.play()
	pass

func on_notepad_close():
	var tween: Tween = create_tween()
	tween.tween_property(self, "offset", Vector2.ZERO, 0.2).set_ease(Tween.EASE_IN)
	tween.play()
	pass
