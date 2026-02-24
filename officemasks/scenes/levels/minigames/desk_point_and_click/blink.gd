extends CanvasLayer
class_name Blink

@onready var parpado_superior := $ParpadoSuperior
@onready var parpado_inferior := $ParpadoInferior
@onready var animation_player := $AnimationPlayer

var current_desk_obj : DeskObject

signal end_blink

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parpado_inferior.visible = false
	parpado_superior.visible = false
	animation_player.animation_finished.connect(_on_blink_finished)
	pass # Replace with function body.

func blink(desk_obj : DeskObject):
	parpado_inferior.visible = true
	parpado_superior.visible = true
	animation_player.play("blink")
	current_desk_obj = desk_obj
	
func _on_blink_finished(_animation_name):
	parpado_inferior.visible = false
	parpado_superior.visible = false
	end_blink.emit()
	
func _move_object_in_blink():
	current_desk_obj.move_object()
