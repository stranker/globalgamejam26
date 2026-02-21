extends Node2D
@onready var menu_music: AudioStream = preload("res://utils/music/681104__seth_makes_sounds__bel-fiore.wav")
@onready var main_anim: AnimationPlayer = $MainAnim
const DIALOGUE_TUTORIAL = preload("uid://bdytw3u1vntbl")

var kitchen_ready: bool = false

func _ready() -> void:
	Global.play_music(menu_music)
	Global.go_to_end_game.connect(on_end_game)
	Global.move_angelica_ending.connect(on_end_move_angelica)
	MinigamesManager.click_point_end.connect(on_end_computer)
	DialogueManager.show_dialogue_balloon(DIALOGUE_TUTORIAL)
	pass


func _on_kitchen_detector_body_entered(body: Node2D) -> void:
	if kitchen_ready: return
	kitchen_ready = true
	main_anim.play("on_kitchen")
	pass # Replace with function body.

func _on_angelica_body_entered(body: Node2D) -> void:
	main_anim.play("end_angelica")
	pass # Replace with function body.

func check_ending():
	Global.check_ending()
	get_tree().call_group("UI", "slow_fade_out")
	pass

func on_end_game():
	await get_tree().create_timer(1).timeout
	main_anim.play("on_end_game")
	pass

func on_end_computer():
	main_anim.play("end_computer")
	pass

func on_end_move_angelica():
	main_anim.play("move_angelica_end")
	pass
