extends Node2D

@export var npc_name: String
@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: AnimatedSprite2D = $Visual/Sprite
@export var dialogue: DialogueResource
@onready var ui_interact_button: UIInteractButton = $UI/UIInteractButton

var used: bool = false

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_use")
	interaction_area.monitoring = false
	MinigamesManager.click_point_start.connect(on_click_start)
	MinigamesManager.click_point_end.connect(on_click_end)
	DialogueManager.dialogue_ended.connect(on_dialogue_end)
	pass

func _on_use():
	if used: return
	used = true
	MinigamesManager.load_click_and_point()
	pass

func on_dialogue_end(dialogue: DialogueResource):
	if dialogue.resource_path.contains("leandro") and dialogue.resource_path.contains("main"):
		sprite.play("on")
		interaction_area.reset()
	pass

func on_click_start():
	pass

func on_click_end():
	sprite.play("idle")
	DialogueManager.show_dialogue_balloon(dialogue)
	pass
