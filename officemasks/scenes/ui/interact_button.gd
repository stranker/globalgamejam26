extends Panel
class_name UIInteractButton

@onready var anim: AnimationPlayer = $Anim

func show_button():
	anim.play("show")
	pass

func hide_button():
	anim.play_backwards("show")
	pass
