extends Area2D

@onready var interaction_area = $InteractionArea
@onready var sprite_2d: Sprite2D = $Sprite2D

signal dialog_started
signal dialog_ended

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_jijear")
	DialogueManager.dialogue_started.connect(on_dialog_started)
	DialogueManager.dialogue_ended.connect(on_dialog_ended)


func _on_jijear():	
	await DialogueManager.call_deferred("show_dialogue_balloon", preload("uid://co8swqfuvjel"))
	
	if Global.objeto_is_basado:
		sprite_2d.texture = preload("uid://vo6n0eugmiyq")
		#Global.objeto_is_basado = false
	else:
		sprite_2d.texture = preload("uid://dp30vhwtxp064")

func on_dialog_started(_dialog):
	dialog_started.emit()
	CinematicCamera.target_node(self, 0.5)

func on_dialog_ended(_dialog):
	dialog_ended.emit()
	CinematicCamera.reset()
