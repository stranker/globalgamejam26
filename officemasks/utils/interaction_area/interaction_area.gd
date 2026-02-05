extends Area2D

class_name InteractionArea

@export var action_name : String = "hablar"
@export var offset_y: float = 38

var interact : Callable = func():
	pass

func _on_body_entered(_body: Node2D) -> void:
	if _body == get_parent(): return
	InteractionManager.register_area(self)


func _on_body_exited(_body: Node2D) -> void:
	if _body == get_parent(): return
	InteractionManager.unregister_area(self)
