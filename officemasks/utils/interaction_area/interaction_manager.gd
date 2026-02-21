extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")

var active_areas = []
var can_interact : bool = true
var active_area: InteractionArea

signal active_area_updated(area: InteractionArea)
signal interacting(area: InteractionArea)
signal end_interact
signal interact_entered
signal interact_empty

func _ready() -> void:
	set_process(false)
	pass

func register_area(area : InteractionArea):
	if active_areas.has(area): return
	area.try_show_button()
	active_areas.push_back(area)
	interacting.connect(area.on_interact)
	set_process(true)
	interact_entered.emit()
	pass
	
func unregister_area(area: InteractionArea):
	if not active_areas.has(area): return
	area.try_hide_button()
	active_areas.erase(area)
	interacting.disconnect(area.on_interact)
	if active_areas.is_empty():
		set_process(false)
		interact_empty.emit()
	pass

# Custom sort for finding the closest area to the player
func _sort_by_distance_to_player(area_1, area_2):
	var area1_to_player = player.global_position.distance_to(area_1.global_position)
	var area2_to_player = player.global_position.distance_to(area_2.global_position)
	return area1_to_player < area2_to_player

func _process(delta: float) -> void:
	if active_areas.size() > 1:
		active_areas.sort_custom(_sort_by_distance_to_player)
	if active_area != active_areas[0]:
		if active_area:
			active_area.try_hide_button()
		active_area = active_areas[0]
		active_area.try_show_button()
		active_area_updated.emit(active_area)
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if not active_areas.is_empty():
			can_interact = false
			interacting.emit(active_area)
			await active_area.interact.call()
			can_interact = true
	pass
