extends Area2D
class_name Door

@export var linked_door : Door
@export var spawn_offset : Vector2
@export var is_loked : bool = false

var is_player_inside: bool = false
@onready var interact_button: UIInteractButton = $UI/InteractButton

func _on_body_entered(body: Node2D) -> void:
	if is_loked: return
	is_player_inside = true
	interact_button.show_button()

func _on_body_exited(body: Node2D) -> void:
	if is_loked: return
	is_player_inside = false
	interact_button.hide_button()

func _unhandled_input(event: InputEvent) -> void:
	if is_loked: return
	if event.is_action_pressed("interact") and is_player_inside:
		_cross_door()
	
func _cross_door() -> void:
	get_tree().get_first_node_in_group("Player").global_position = linked_door.global_position + spawn_offset


func _on_angelica_on_main_dialog_end() -> void:
	is_loked = false
	pass # Replace with function body.

func force_open():
	is_loked = false
	pass
