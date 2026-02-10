extends Node2D
@onready var desk: Node2D = $Desk
@onready var blink: CanvasLayer = $Blink

signal end_game

var counter: int = 0

func _ready() -> void:
	var desk_children = desk.get_children()
	for desk_obj in desk_children:
		if desk_obj is DeskObject :
			desk_obj.blink.connect(emit_transition.bind(desk_obj))

func emit_transition(desk_obj):
	blink.blink(desk_obj)
	counter += 1
	if counter >= 4:
		await get_tree().create_timer(2).timeout
		end_game.emit()
