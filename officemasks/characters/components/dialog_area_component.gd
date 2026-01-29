extends Area2D
class_name DialogAreaComponent

var is_player_inside: bool = false

@export var dialogues: Resource

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
	if event.is_action_pressed("interact") and is_player_inside:
		DialogueManager.show_dialogue_balloon(dialogues)
	pass

func on_dialog_started(dialog):
	dialog_started.emit()
	pass

func on_dialog_ended(dialog):
	dialog_ended.emit()
	pass
