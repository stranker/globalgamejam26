extends Area2D

@export var npc_name: String
@export var dialogue: Resource
@onready var interaction_area: InteractionArea = $InteractionArea

@export var easy_game: PackedScene
@export var hard_game: PackedScene
var go_to_dialog_b: bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var used: bool = false

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_use")
	MinigamesManager.connected_game_end.connect(on_end_game)
	pass

func _on_use():
	if used: return
	interaction_area.monitoring = false
	used = true
	animated_sprite_2d.play("Use")
	await animated_sprite_2d.animation_finished
	DialogueManager.show_dialogue_balloon(dialogue)
	pass

func load_easy_game(game_npc_name: String):
	if npc_name != game_npc_name: return
	MinigamesManager.load_connected_game(easy_game, npc_name)
	go_to_dialog_b = false
	pass

func load_hard_game(game_npc_name: String):
	if npc_name != game_npc_name: return
	MinigamesManager.load_connected_game(hard_game, npc_name)
	go_to_dialog_b = true
	pass

func on_end_game(game_name: String):
	if game_name != npc_name: return
	get_tree().call_group("Angelica", "set_go_to_dialog_b", go_to_dialog_b)
	pass
