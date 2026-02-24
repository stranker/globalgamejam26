extends Node2D

@export var npc_name: String
@export var dialogue: Resource
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sound: AudioStreamPlayer2D = $Sound

@export var easy_game: PackedScene
@export var hard_game: PackedScene
@onready var ui_interact_button: UIInteractButton = $UI/UIInteractButton
@onready var steam: CPUParticles2D = $Steam
@onready var sprite: AnimatedSprite2D = $Visual/Sprite

var used: bool = false

signal coffee_done(game_diff)

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_use")
	MinigamesManager.connected_game_end.connect(on_game_end)
	coffee_done.connect(Global.done_coffee)
	pass

func _on_use():
	used = true
	sprite.play("Use")
	steam.emitting = true
	sound.play()
	await sprite.animation_finished
	DialogueManager.show_dialogue_balloon(dialogue)
	steam.emitting = false
	interaction_area.monitoring = false
	pass

func on_game_end(game_name, diff, win):
	if game_name != "Angelica": return
	coffee_done.emit(diff)
	DialogueManager.show_dialogue_balloon(dialogue, "game_result")
	pass
