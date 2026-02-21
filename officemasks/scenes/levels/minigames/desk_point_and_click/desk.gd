extends Node2D
@onready var desk: Node2D = $Desk
@onready var blink: CanvasLayer = $Blink
@onready var box_anim: AnimationPlayer = $Box/Anim

const DIALOGUE_TUTORIAL_ESCRITORIO = preload("uid://ql52maudfstm")


signal end_game

var counter: int = 0

func _ready() -> void:
	var desk_children = desk.get_children()
	for desk_obj in desk_children:
		if desk_obj is DeskObject :
			desk_obj.blink.connect(emit_transition.bind(desk_obj))
	DialogueManager.show_dialogue_balloon(DIALOGUE_TUTORIAL_ESCRITORIO)

func emit_transition(desk_obj):
	box_anim.play("object")
	blink.blink(desk_obj)
	counter += 1
	if counter >= 5:
		await get_tree().create_timer(2).timeout
		end_game.emit()
