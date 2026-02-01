extends Node2D
@onready var desk: Node2D = $Desk
@onready var blink: CanvasLayer = $Blink

signal end_game

var counter: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var desk_children = desk.get_children()
	for desk_obj in desk_children:
		if desk_obj is DeskObject :
			desk_obj.blink.connect(emit_transition.bind(desk_obj))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func emit_transition(desk_obj):
	blink.blink(desk_obj)
	counter += 1
	if counter >= 4:
		end_game.emit()
