extends Node2D

@onready var vignette: Vignette = $Camera2D/Vignette

func _ready() -> void:
	vignette.fade_out()
	pass
