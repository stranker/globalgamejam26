extends Area2D
class_name InteractionArea

enum Type { DIALOG, OBJECT }

@export var interact_button : UIInteractButton
@export var type: Type

signal end_interact


var interact : Callable = func():
	pass

func _ready() -> void:
	pass

func on_interact(area):
	interacted()
	pass

func on_end_interact():
	end_interact.emit()
	pass

func _on_body_entered(_body: Node2D) -> void:
	InteractionManager.register_area(self)
	pass

func _on_body_exited(_body: Node2D) -> void:
	InteractionManager.unregister_area(self)
	pass

func interacted():
	if interact_button:
		interact_button.pressed()
	monitoring = false
	pass

func reset():
	if interact_button:
		interact_button.reset()
	monitoring = true
	pass

func enable():
	set_deferred("monitoring", true)
	pass

func disable():
	set_deferred("monitoring", false)
	try_hide_button()
	pass

func try_show_button():
	if interact_button:
		interact_button.show_button()
	pass

func try_hide_button():
	if interact_button:
		interact_button.hide_button()
	pass
