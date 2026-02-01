extends Node2D
@onready var menu_music: AudioStream = preload("res://utils/music/826622__xkeril__memories-of-a-sweet-summer-music-loop.wav")

func _ready() -> void:
	Global.play_music(menu_music)
