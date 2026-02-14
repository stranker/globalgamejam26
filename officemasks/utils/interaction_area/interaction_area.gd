extends Area2D
class_name InteractionArea


@export var action_name : String = "hablar"
@export var interact_button : UIInteractButton

var interact : Callable = func():
	pass

func _ready() -> void:
	pass

func on_interact(area):
	interacted()
	pass

func _on_body_entered(_body: Node2D) -> void:
	InteractionManager.register_area(self)
	if interact_button:
		interact_button.show_button()

func _on_body_exited(_body: Node2D) -> void:
	InteractionManager.unregister_area(self)
	if interact_button:
		interact_button.hide_button()

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
