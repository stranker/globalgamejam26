extends Node2D
@onready var menu_music: AudioStream = preload("res://utils/music/681104__seth_makes_sounds__bel-fiore.wav")
@onready var main_anim: AnimationPlayer = $MainAnim

var kitchen_ready: bool = false

func _ready() -> void:
	Global.play_music(menu_music)
	Global.go_to_end_game.connect(on_end_game)
	TasksManager.all_completed.connect(on_end_game)
	pass


func _on_kitchen_detector_body_entered(body: Node2D) -> void:
	if kitchen_ready: return
	kitchen_ready = true
	main_anim.play("on_kitchen")
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_1:
			if kitchen_ready: return
			kitchen_ready = true
			main_anim.play("on_kitchen")
		if event.keycode == KEY_2:
			if kitchen_ready: return
			kitchen_ready = true
			main_anim.play("end_angelica")
		if event.keycode == KEY_3:
			if kitchen_ready: return
			TasksManager.trigger_all_completed()
			#main_anim.play("on_end_game")


func _on_angelica_body_entered(body: Node2D) -> void:
	main_anim.play("end_angelica")
	pass # Replace with function body.

func check_ending():
	Global.check_ending()
	pass

func on_end_game():
	main_anim.play("on_end_game")
	pass
