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

signal good_ending
signal bad_ending

signal go_to_end_game

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music_player)

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
	get_tree().call_group("UI", "mask_break")

func check_ending():
	if broken_mask_score >= MAX_BROKEN_SCORE:
		good_ending.emit()
	else:
		bad_ending.emit()
	pass

func go_to_end():
	go_to_end_game.emit()
	pass

func reset_game():
	broken_mask_score = 0
	_on_scene_changed(Scenes.MAIN_MENU)
	pass
