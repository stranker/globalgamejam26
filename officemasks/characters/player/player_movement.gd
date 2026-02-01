extends CharacterBody2D
class_name Player

@export var movement_speed : float = 100
@export var enable_y: bool = true
@onready var mask: Sprite2D = $Mask
var character_direction : Vector2
var current_mask_score : int
var mask_textures : Array[Texture] = [preload("uid://chp6ut3m7ur5n"), preload("uid://4mvpumrpixyj"), preload("uid://cegd753eeoiv6"), preload("uid://cjb30ibov5ayw"), preload("uid://2dp85w7vjn4r")]

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_dialog_start)
	DialogueManager.dialogue_ended.connect(_on_dialog_ended)
	current_mask_score = 0
	pass

func _physics_process(delta):
	character_direction.x = Input.get_axis("move_left", "move_right")
	if enable_y:
		character_direction.y = Input.get_axis("move_up", "move_down")
	character_direction = character_direction.normalized()
	
	#flip
	if character_direction.x < 0: %Sprite.flip_h = true
	elif character_direction.x > 0: %Sprite.flip_h = false
	
	if character_direction:
		velocity = character_direction * movement_speed
		if %Sprite.animation != "Walking": %Sprite.animation = "Walking"
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		if %Sprite.animation != "Idle": %Sprite.animation = "Idle"
		
	move_and_slide()
	pass

func _on_dialog_start(dialogue):
	set_physics_process(false)
	pass

func _on_dialog_ended(dialogue):
	if current_mask_score < Global.broken_mask_score && Global.broken_mask_score < mask_textures.size():
		get_tree().call_group("UI", "mask_break")
		current_mask_score = Global.broken_mask_score
		mask.texture = mask_textures[current_mask_score]
	set_physics_process(true)
	pass
