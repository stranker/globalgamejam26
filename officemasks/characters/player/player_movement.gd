extends CharacterBody2D
class_name Player

@onready var footsteps: AudioStreamPlayer2D = $Footsteps
@export var movement_speed : float = 100
@export var enable_y: bool = true
var character_direction : Vector2

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_dialog_start)
	DialogueManager.dialogue_ended.connect(_on_dialog_ended)
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
		if not footsteps.playing:
			footsteps.play()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		if %Sprite.animation != "Idle": %Sprite.animation = "Idle"
		if footsteps.playing:
			footsteps.stop()
		
	move_and_slide()
	pass

func _on_dialog_start(dialogue):
	if footsteps.playing:
		footsteps.stop()
	set_physics_process(false)
	pass

func _on_dialog_ended(dialogue):
	set_physics_process(true)
	pass
