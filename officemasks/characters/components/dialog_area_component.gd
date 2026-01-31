extends Area2D
class_name DialogAreaComponent

var is_player_inside: bool = false
var interacting: bool = false

@export var dialogues: Array[Resource]
@export var current_dialogue_idx = 0
@export var use_advance_dialog: bool = false
@export var use_random_dialog: bool = false

signal player_entered
signal player_exited
signal dialog_started
signal dialog_ended

func _ready() -> void:
	DialogueManager.dialogue_started.connect(on_dialog_started)
	DialogueManager.dialogue_ended.connect(on_dialog_ended)
	pass

func _on_body_entered(body: Node2D) -> void:
	is_player_inside = true
	player_entered.emit()
	pass # Replace with function body.

func _on_body_exited(body: Node2D) -> void:
	is_player_inside = false
	player_exited.emit()
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if interacting or dialogues.is_empty(): return
	if event.is_action_pressed("interact") and is_player_inside:
		interacting = true
		var dialog : Resource
		if use_random_dialog:
			dialog = dialogues.pick_random()
		else:
			dialog = dialogues[current_dialogue_idx]
		DialogueManager.show_dialogue_balloon(dialog)
	pass

func on_dialog_started(dialog):
	if not dialogues.has(dialog): return
	dialog_started.emit()
	CinematicCamera.target_node(self, 0.5)
	pass

func on_dialog_ended(dialog):
	if not dialogues.has(dialog): return
	dialog_ended.emit()
	if use_advance_dialog and not use_random_dialog:
		current_dialogue_idx += 1
		current_dialogue_idx = clamp(current_dialogue_idx, 0, dialogues.size() - 1)
	CinematicCamera.reset()
	interacting = false
	pass
