extends Node2D
class_name Door

@export var linked_door : Door
@export var spawn_offset : Vector2
@export var is_locked : bool = true:
	set(new_value):
		is_locked = new_value
		if interaction_area:
			if is_locked:
				interaction_area.disable()
			else:
				interaction_area.enable()

@onready var interact_button: UIInteractButton = $UI/InteractButton
@onready var door_sfx: AudioStreamPlayer2D = $DoorSound
var is_player_inside: bool = false
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_use")
	interaction_area.disable()
	pass

func _on_use() -> void:
	get_tree().call_group("UI", "fade_out")
	door_sfx.play()
	var player: Player = get_tree().get_first_node_in_group("Player")
	player.global_position = linked_door.global_position + spawn_offset
	player.set_state(player.State.IDLE)
	interaction_area.reset()
	pass

func _on_angelica_on_main_dialog_end() -> void:
	is_locked = false
	get_tree().call_group("Door", "force_open")
	pass # Replace with function body.

func force_open():
	is_locked = false
	pass

func _on_interaction_area_body_entered(body: Node2D) -> void:
	is_player_inside = true
	pass # Replace with function body.


func _on_interaction_area_body_exited(body: Node2D) -> void:
	is_player_inside = false
	pass # Replace with function body.
