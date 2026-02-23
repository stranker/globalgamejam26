extends CharacterBody2D
class_name Player

enum State { NONE, IDLE, MOVE, INTERACT }

@onready var footsteps: AudioStreamPlayer2D = $Footsteps
@export var movement_speed : float = 100
@export var enable_y: bool = true
var character_direction : Vector2
var state: State = State.NONE
@onready var sprite: AnimatedSprite2D = %Sprite
@onready var player_state: Label = $HUD/PlayerState

signal state_changed(state: State)

func _ready() -> void:
	DialogueManager.dialogue_started.connect(_on_dialog_start)
	DialogueManager.dialogue_ended.connect(_on_dialog_ended)
	MinigamesManager.game_started.connect(on_game_started)
	MinigamesManager.click_point_start.connect(on_game_started)
	MinigamesManager.click_point_end.connect(on_click_end)
	MinigamesManager.connected_game_end.connect(on_game_end)
	InteractionManager.interacting.connect(on_interacting)
	Global.talking_npc.connect(on_talking_npc)
	set_state(State.IDLE)
	pass

func set_state(new_state: State):
	if state == new_state: return
	state = new_state
	player_state.text = "Player state:" + State.keys()[state]
	match state:
		State.IDLE:
			on_idle_state()
		State.MOVE:
			on_move_state()
		State.INTERACT:
			on_interact_state()
	state_changed.emit(state)
	pass

func on_idle_state():
	set_physics_process(true)
	sprite.play("Idle")
	pass

func on_move_state():
	set_physics_process(true)
	sprite.play("Walking")
	pass

func on_interact_state():
	set_physics_process(false)
	sprite.play("Idle")
	pass

func _physics_process(delta):
	character_direction.x = Input.get_axis("move_left", "move_right")
	if enable_y:
		character_direction.y = Input.get_axis("move_up", "move_down")
	character_direction = character_direction.normalized()
	
	#flip
	if character_direction.x < 0: sprite.flip_h = true
	elif character_direction.x > 0: sprite.flip_h = false
	
	if character_direction:
		velocity = character_direction * movement_speed
		set_state(State.MOVE)
		if not footsteps.playing:
			footsteps.play()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		
		if footsteps.playing:
			footsteps.stop()
		set_state(State.IDLE)
		
	move_and_slide()
	pass

func on_game_started():
	set_state(State.INTERACT)
	pass

func on_game_end(npc, type, win):
	set_state(State.IDLE)
	pass

func _on_dialog_start(dialogue):
	if footsteps.playing:
		footsteps.stop()
	set_state(State.INTERACT)
	pass

func on_click_end():
	set_state(State.INTERACT)
	pass

func _on_dialog_ended(dialogue):
	if MinigamesManager.is_minigame_open: return
	if Global.game_over: return
	set_state(State.IDLE)
	pass

func on_interacting(area: Node2D):
	set_state(State.INTERACT)
	look_at_npc(area)
	pass

func on_talking_npc(npc: Node2D):
	look_at_npc(npc)
	pass

func look_at_npc(npc):
	%Sprite.flip_h = global_position.direction_to(npc.global_position).x < 0
	pass
