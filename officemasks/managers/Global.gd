extends Node

enum Scenes { MAIN_MENU, GAME }
const SCENE_PATHS := {
	Scenes.MAIN_MENU: "res://scenes/ui/main_menu.tscn",
	Scenes.GAME: "res://scenes/levels/test/testing_level.tscn"
}
var current_scene : Scenes
var score : int = 0
var objeto_is_basado = true

func _on_scene_changed(scene: Scenes) -> void:
	if not SCENE_PATHS.has(scene):
		push_error("Scene no mapeada: %s" % [scene])
		return
	current_scene = scene
	var path: String = SCENE_PATHS[scene]
	get_tree().change_scene_to_file(path)
