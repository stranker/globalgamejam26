@tool
extends Area2D
class_name DeskObject

@export var linked_object : Area2D
@onready var sprite_2d := $Sprite2D
@export var texture : Texture:
	set(new_texture):
		texture = new_texture
		if sprite_2d:
			sprite_2d.texture = new_texture
var is_highlighted : bool 

signal blink

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_highlighted = false
	sprite_2d.texture = texture
	if linked_object != null:
		linked_object.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_action") && is_highlighted && linked_object != null:
		blink.emit()

func _on_mouse_entered() -> void:
	is_highlighted = true


func _on_mouse_exited() -> void:
	is_highlighted = false
	pass # Replace with function body.

func move_object():
	linked_object.visible = true
	self.visible = false
