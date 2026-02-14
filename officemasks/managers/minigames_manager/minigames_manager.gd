extends Node

enum GameType { EASY, HARD }
var game_type: GameType = GameType.EASY

signal connected_game_end(npc_name: String, game_type: GameType, win: bool)
signal game_started()
signal click_point_start
signal click_point_end

var last_game_easy_option: bool = false
var last_game_won: bool = false

var is_minigame_open: bool = false

func load_easy_game(npc_name: String):
	get_tree().call_group("NPC", "load_easy_game", npc_name)
	game_type = GameType.EASY
	pass

func load_hard_game(npc_name: String):
	get_tree().call_group("NPC", "load_hard_game", npc_name)
	game_type = GameType.HARD
	pass

func load_connected_game(game_scene: PackedScene, npc_name: String):
	var canvas_layer: CanvasLayer = CanvasLayer.new()
	canvas_layer.layer = 5
	get_tree().root.add_child(canvas_layer)
	var game : ConnectGridGameScene = game_scene.instantiate()
	game.win.connect(_on_connected_game_win.bind(npc_name))
	game.lose.connect(_on_connected_game_lose.bind(npc_name))
	canvas_layer.add_child(game)
	is_minigame_open = true
	game_started.emit()
	await game.end_game
	canvas_layer.queue_free()
	is_minigame_open = false
	pass

func load_click_and_point():
	var canvas_layer: CanvasLayer = CanvasLayer.new()
	canvas_layer.layer = 5
	get_tree().root.add_child(canvas_layer)
	var game = preload("res://scenes/levels/minigames/desk_point_and_click/desk.tscn").instantiate()
	canvas_layer.add_child(game)
	click_point_start.emit()
	await game.end_game
	click_point_end.emit()
	canvas_layer.queue_free()
	pass

func _on_connected_game_win(npc_name: String):
	connected_game_end.emit(npc_name, game_type, true)
	last_game_won = true
	pass

func _on_connected_game_lose(npc_name: String):
	connected_game_end.emit(npc_name, game_type, false)
	last_game_won = false
	pass
