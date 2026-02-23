extends Control
class_name DeskObject

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var linked_object : DeskObject

var is_highlighted : bool 

signal blink

var is_selected: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_highlighted = false
	if linked_object != null:
		linked_object.hide()
	pass

func move_object():
	linked_object.visible = true
	self.visible = false


func _on_texture_mouse_entered() -> void:
	is_highlighted = true
	animation_player.play("highlighted")
	pass # Replace with function body.


func _on_texture_mouse_exited() -> void:
	is_highlighted = false
	animation_player.play_backwards("highlighted")
	pass # Replace with function body.


func _on_texture_gui_input(event: InputEvent) -> void:
	if not linked_object: return
	if is_selected: return
	if event.is_action_pressed("mouse_action") and is_highlighted:
		blink.emit()
		is_selected = true
	pass # Replace with function body.
