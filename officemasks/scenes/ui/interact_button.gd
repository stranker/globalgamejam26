extends Panel
class_name UIInteractButton

@onready var anim: AnimationPlayer = $Anim

var is_hide: bool = true

func show_button():
	if not is_hide: return
	anim.play("show")
	is_hide = false
	pass

func hide_button():
	if is_hide: return
	anim.play_backwards("show")
	is_hide = true
	pass
