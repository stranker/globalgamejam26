extends Area2D

@export var linked_object : Area2D
var is_highlighted : bool 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_highlighted = false
	if linked_object != null:
		linked_object.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_action") && is_highlighted && linked_object != null:
		linked_object.visible = true
		self.visible = false

func _on_mouse_entered() -> void:
	is_highlighted = true


func _on_mouse_exited() -> void:
	is_highlighted = false
	pass # Replace with function body.
