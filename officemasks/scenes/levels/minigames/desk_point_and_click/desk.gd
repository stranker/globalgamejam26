extends Control
@onready var desk: Control = $Desk
@onready var blink: Blink = $Blink
@onready var box_anim: AnimationPlayer = $Box/Anim
@onready var sound: AudioStreamPlayer = $Sound

const DIALOGUE_TUTORIAL_ESCRITORIO = preload("uid://ql52maudfstm")

signal end_game

var counter: int = 0
var can_move: bool = false

func _ready() -> void:
	can_move = true
	var desk_children = desk.get_children()
	for desk_obj in desk_children:
		if desk_obj is DeskObject :
			desk_obj.blink.connect(emit_transition.bind(desk_obj))
	DialogueManager.show_dialogue_balloon(DIALOGUE_TUTORIAL_ESCRITORIO)
	pass

func emit_transition(desk_obj):
	if not can_move: return
	sound.play()
	can_move = false
	box_anim.play("object")
	blink.blink(desk_obj)
	await blink.end_blink
	counter += 1
	can_move = true
	if counter >= desk.get_child_count():
		await get_tree().create_timer(2).timeout
		end_game.emit()
	pass
