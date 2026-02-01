extends Node

signal connected_game_end(npc_name: String)
signal game_started()

var last_game_won: bool = false
var last_game_easy_option: bool = false

var is_minigame_open: bool = false

func load_easy_game(npc_name: String):
	get_tree().call_group("NPC", "load_easy_game", npc_name)
	last_game_easy_option = true
	pass

func load_hard_game(npc_name: String):
	get_tree().call_group("NPC", "load_hard_game", npc_name)
	last_game_easy_option = false
	pass

func load_connected_game(game_scene: PackedScene, npc_name: String):
	var canvas_layer: CanvasLayer = CanvasLayer.new()
	canvas_layer.layer = 5
	get_tree().root.add_child(canvas_layer)
	var game : ConnectGridGameScene = game_scene.instantiate()
	game.win.connect(_on_connected_game_win.bind(game, npc_name))
	game.lose.connect(_on_connected_game_lose.bind(game, npc_name))
	canvas_layer.add_child(game)
	is_minigame_open = true
	game_started.emit()
	await game.end_game
	canvas_layer.queue_free()
	is_minigame_open = false
	pass

func _on_connected_game_win(game: ConnectGridGameScene, npc_name: String):
	last_game_won = true
	connected_game_end.emit(npc_name)
	pass

func _on_connected_game_lose(game: ConnectGridGameScene, npc_name: String):
	last_game_won = false
	connected_game_end.emit(npc_name)
	pass
