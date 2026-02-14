extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")

var active_areas = []
var can_interact : bool = true
var active_area: InteractionArea

signal interacting(area)

func _ready() -> void:
	set_process(false)

func register_area(area : InteractionArea):
	if active_areas.has(area): return
	active_areas.push_back(area)
	interacting.connect(area.on_interact)
	pass
	
func unregister_area(area: InteractionArea):
	if not active_areas.has(area): return
	active_areas.erase(area)
	interacting.disconnect(area.on_interact)
	pass

# Custom sort for finding the closest area to the player
func _sort_by_distance_to_player(area_1, area_2):
	var area1_to_player = player.global_position.distance_to(area_1.global_position)
	var area2_to_player = player.global_position.distance_to(area_2.global_position)
	return area1_to_player < area2_to_player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if not active_areas.is_empty():
			can_interact = false
			active_area = active_areas[0]
			interacting.emit(active_area)
			await active_area.interact.call()
			
			can_interact = true
