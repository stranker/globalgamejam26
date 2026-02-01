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
