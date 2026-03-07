extends CharacterBody2D
class_name NPC

enum State { NONE, IDLE }
var state: State = State.NONE

@onready var sprite: AnimatedSprite2D = $Visual/Sprite
@onready var proximity_area_component: ProximityAreaComponent = $ProximityAreaComponent
@onready var npc_name_label: Label = $UI/NPCName
@onready var npc_name_anim: AnimationPlayer = $UI/NPCName/Anim
@onready var interact_button: UIInteractButton = $UI/InteractButton
@onready var ui: Control = $UI
@onready var interaction_area: InteractionArea = $InteractionArea


@export var npc_name: String
@export var main_dialogue: DialogueResource
@export var dialogue_a: DialogueResource
@export var dialogue_b: DialogueResource
var next_dialogue: DialogueResource
@export var easy_game: PackedScene
@export var hard_game: PackedScene

@export var use_main_dialog: bool = true

var waiting_for_minigame: bool = false

var target_position: Vector2
var player: Player
var talking: bool = false
var enabled: bool = true

signal on_main_dialog_end()
signal talking_npc(npc: Node2D)

func _ready() -> void:
	set_state(State.IDLE)
	interaction_area.interact = Callable(self, "_on_talk")
	proximity_area_component.player_entered.connect(on_proximity_player_entered)
	proximity_area_component.player_exited.connect(on_proximity_player_exited)
	MinigamesManager.connected_game_end.connect(on_connected_game_end)
	DialogueManager.dialogue_ended.connect(on_dialog_ended)
	DialogueManager.dialogue_started.connect(on_dialog_started)
	talking_npc.connect(Global.on_talking_npc)
	player = get_tree().get_first_node_in_group("Player")
	npc_name_label.text = npc_name
	next_dialogue = main_dialogue
	set_enabled(false)
	pass

func set_enabled(value: bool):
	if enabled == value: return
	enabled = value
	if enabled:
		interaction_area.enable()
	else:
		interaction_area.disable()
	pass

func set_state(new_state: State):
	if state == new_state: return
	state = new_state
	match state:
		State.IDLE:
			on_idle_state()
	pass

func on_idle_state():
	sprite.play("Idle")
	pass

func on_walk_state():
	sprite.play("Walking")
	set_physics_process(true)
	pass

func on_dialog_started(dialog):
	if not dialog.resource_path.contains(npc_name.to_lower()): return
	talking = true
	sprite.flip_h = global_position.direction_to(player.global_position).x > 0.1
	pass

func on_dialog_ended(dialog: DialogueResource):
	if not dialog.resource_path.contains(npc_name.to_lower()): return
	talking = false
	if dialog == main_dialogue:
		on_main_dialog_end.emit()
		if dialogue_a or dialogue_b:
			waiting_for_minigame = true
	else:
		next_dialogue = null
		interaction_area.disable()
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
	pass

func load_hard_game(game_npc_name: String):
	if npc_name != game_npc_name: return
	MinigamesManager.load_connected_game(hard_game, npc_name)
	pass

func _on_talk():
	if not next_dialogue or talking: return
	play_next_dialogue()
	pass

func on_connected_game_end(game_name: String, game_type: MinigamesManager.GameType, win: bool):
	if not waiting_for_minigame: return
	if game_name != npc_name: return
	if dialogue_a or dialogue_b:
		if win:
			next_dialogue = dialogue_a if game_type == MinigamesManager.GameType.EASY else dialogue_b
		else:
			next_dialogue = dialogue_a
	if npc_name != "Angelica":
		play_next_dialogue()
	pass

func play_next_dialogue():
	DialogueManager.show_dialogue_balloon(next_dialogue)
	talking_npc.emit(self)
	pass
