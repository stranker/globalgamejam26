extends Node2D
@onready var menu_music: AudioStream = preload("res://utils/music/681104__seth_makes_sounds__bel-fiore.wav")
@onready var main_anim: AnimationPlayer = $MainAnim

var kitchen_ready: bool = false

func _ready() -> void:
	Global.play_music(menu_music)


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
			#get_tree().call_group("Door", "force_open")


func _on_angelica_body_entered(body: Node2D) -> void:
	main_anim.play("end_angelica")
	pass # Replace with function body.
