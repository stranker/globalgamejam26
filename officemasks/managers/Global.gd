extends Node

enum Scenes { MAIN_MENU, GAME }
const SCENE_PATHS := {
	Scenes.MAIN_MENU: "res://scenes/ui/main_menu.tscn",
	Scenes.GAME: "res://scenes/game/base_scene.tscn"
}
var current_scene : Scenes
var broken_mask_score : int = 0
const MAX_BROKEN_SCORE: int = 3
var player: Node2D
var music_player: AudioStreamPlayer
var current_music: AudioStream
var is_mobile_game: bool
var is_game_paused: bool
var game_over: bool = false

signal good_ending
signal bad_ending

signal go_to_end_game
signal planti_regada(value: bool)
signal coffe_done(diff)
signal move_angelica_ending()
signal talking_npc(npc: Node2D)
signal game_paused(paused: bool)

func _ready() -> void:
	is_mobile_game = OS.get_name() == "Android" or true
	process_mode = Node.PROCESS_MODE_ALWAYS
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_player)
	TasksManager.all_completed.connect(on_tasks_completed)
	pass

func _on_scene_changed(scene: Scenes) -> void:
	if not SCENE_PATHS.has(scene):
		push_error("Scene no mapeada: %s" % [scene])
		return
	current_scene = scene
	var path: String = SCENE_PATHS[scene]
	get_tree().change_scene_to_file(path)
	
func play_music(stream: AudioStream, restart: bool = false) -> void:
	if stream == null:
		return
	if current_music == stream and music_player.playing and not restart:
		return

	current_music = stream
	music_player.stream = stream
	music_player.play()

func stop_music() -> void:
	if music_player:
		music_player.stop()
		
func break_mask_animate():
	broken_mask_score += 1
	get_tree().call_group("UI", "mask_break")

func check_ending():
	if broken_mask_score >= MAX_BROKEN_SCORE:
		good_ending.emit()
	else:
		bad_ending.emit()
	game_over = true
	pass

func go_to_end():
	go_to_end_game.emit()
	pass

func reset_game():
	game_over = false
	broken_mask_score = 0
	_on_scene_changed(Scenes.MAIN_MENU)
	TasksManager.reset()
	pass

func on_tasks_completed():
	go_to_end()
	pass

func set_planti_regada(value: bool):
	planti_regada.emit(value)
	pass

func done_coffee(diff):
	coffe_done.emit(diff)
	pass

func ending_move_angelica():
	move_angelica_ending.emit()
	pass

func on_talking_npc(npc: Node2D):
	talking_npc.emit(npc)
	pass

func on_game_paused(paused: bool):
	is_game_paused = paused
	game_paused.emit(is_game_paused)
	pass
