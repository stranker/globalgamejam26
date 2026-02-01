extends CharacterBody2D
class_name NPC

enum State { NONE, IDLE, WALK }
var state: State = State.NONE

@onready var timer: Timer = $Timer
@onready var sprite: AnimatedSprite2D = $Visual/Sprite
@onready var proximity_area_component: ProximityAreaComponent = $ProximityAreaComponent
@onready var npc_name_label: Label = $UI/NPCName
@onready var npc_name_anim: AnimationPlayer = $UI/NPCName/Anim
@onready var interact_button: UIInteractButton = $UI/InteractButton
@onready var ui: Control = $UI
@onready var interaction_area: InteractionArea = $InteractionArea


@export var npc_name: String
@export var speed: float = 50
@export var walk_points: Array[Marker2D]
@export var max_idle_wait_time: float = 2
@export var min_idle_wait_time: float = 1
@export var use_movement: bool = true
@export var main_dialogue: DialogueResource
@export var dialogue_a: DialogueResource
@export var dialogue_b: DialogueResource
@export var easy_game: PackedScene
@export var hard_game: PackedScene
@export var task: Task

@export var go_to_dialog_b: bool = true
@export var use_main_dialog: bool = true
@export var talked: bool = false

var coffe_done: bool = false

var target_position: Vector2
var player: Player

func _ready() -> void:
	set_state(State.IDLE)
	interaction_area.interact = Callable(self, "_on_talk")
	proximity_area_component.player_entered.connect(on_proximity_player_entered)
	proximity_area_component.player_exited.connect(on_proximity_player_exited)
	MinigamesManager.connected_game_end.connect(on_connected_game_end)
	player = get_tree().get_first_node_in_group("Player")
	npc_name_label.text = npc_name
	pass

func set_state(new_state: State):
	if state == new_state: return
	state = new_state
	match state:
		State.IDLE:
			on_idle_state()
		State.WALK:
			if use_movement:
				on_walk_state()
			else:
				set_state(State.IDLE)
	pass

func _physics_process(delta: float) -> void:
	if global_position.distance_to(target_position) > 10:
		velocity = speed * global_position.direction_to(target_position)
		sprite.flip_h = velocity.x > 0.1
	else:
		set_state(State.IDLE)
	move_and_slide()
	pass

func on_idle_state():
	sprite.play("Idle")
	set_physics_process(false)
	if use_movement:
		timer.wait_time = randf_range(min_idle_wait_time, max_idle_wait_time)
		timer.start()
	pass

func on_walk_state():
	sprite.play("Walking")
	set_physics_process(true)
	pass

func _on_timer_timeout() -> void:
	assert(!walk_points.is_empty(), "Falta agregar nodos Marker2D a la variable walk_points")
	target_position = walk_points.pick_random().global_position
	set_state(State.WALK)
	pass # Replace with function body.

func on_dialog_started():
	sprite.flip_h = global_position.direction_to(player.global_position).x > 0.1
	ui.hide()
	pass

func on_dialog_ended():
	ui.show()
	pass

func on_proximity_player_entered():
	npc_name_anim.play("show")
	pass

func on_proximity_player_exited():
	npc_name_anim.play_backwards("show")
	pass

func load_easy_game(game_npc_name: String):
	if npc_name != game_npc_name: return
	MinigamesManager.load_connected_game(easy_game, npc_name)
	go_to_dialog_b = false
	pass

func load_hard_game(game_npc_name: String):
	if npc_name != game_npc_name: return
	MinigamesManager.load_connected_game(hard_game, npc_name)
	go_to_dialog_b = true
	pass

func _on_talk():
	if talked: return
	talked = true
	if coffe_done:
		if go_to_dialog_b:
			DialogueManager.show_dialogue_balloon(dialogue_b)
		else:
			DialogueManager.show_dialogue_balloon(dialogue_a)
		task.complete()
	else:
		DialogueManager.show_dialogue_balloon(main_dialogue)
	pass

func _on_dialog_area_body_entered(body: Node2D) -> void:
	if talked: return
	interact_button.show_button()
	pass # Replace with function body.


func _on_dialog_area_body_exited(body: Node2D) -> void:
	if talked: return
	interact_button.hide_button()
	pass # Replace with function body.

func on_connected_game_end(game_name: String):
	if talked: return
	if game_name != npc_name: return
	if go_to_dialog_b:
		DialogueManager.show_dialogue_balloon(dialogue_b)
	else:
		DialogueManager.show_dialogue_balloon(dialogue_a)
	task.complete()
	pass

func set_go_to_dialog_b(value: bool):
	go_to_dialog_b = value
	talked = false
	coffe_done = true
	pass
