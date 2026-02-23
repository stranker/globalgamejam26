extends Node2D

var player: Player

var active_areas = []
var can_interact : bool = true
var active_area: InteractionArea

signal active_area_updated(area: InteractionArea)
signal interacting(area: InteractionArea)
signal interact_entered
signal interact_empty

func _ready() -> void:
	set_process(false)
	pass

func register_area(area : InteractionArea):
	active_areas.push_back(area)
	if not active_area:
		active_area = area
		area.try_show_button()
	interacting.connect(area.on_interact)
	if active_areas.size() > 1:
		set_process(true)
	interact_entered.emit()
	print_debug(self)
	pass
	
func unregister_area(area: InteractionArea):
	active_areas.erase(area)
	area.try_hide_button()
	interacting.disconnect(area.on_interact)
	if active_areas.is_empty():
		active_area = null
		set_process(false)
		interact_empty.emit()
	elif active_areas.size() == 1:
		await get_tree().process_frame
		set_process(false)
		active_area = active_areas.front()
		active_area.try_show_button()
	print_debug(self)
	pass

func _sort_by_distance_to_player(area_1, area_2):
	var area1_to_player = player.global_position.distance_to(area_1.global_position)
	var area2_to_player = player.global_position.distance_to(area_2.global_position)
	return area1_to_player < area2_to_player

func _process(delta: float) -> void:
	sort_areas()
	if active_area != active_areas.front():
		if active_area:
			active_area.try_hide_button()
		active_area = active_areas.front()
		active_area.try_show_button()
		active_area_updated.emit(active_area)
	pass

func sort_areas():
	if active_areas.size() > 1:
		active_areas.sort_custom(_sort_by_distance_to_player)
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and event.is_pressed():
		if active_area and can_interact:
			can_interact = false
			var last_area: InteractionArea = active_area
			interacting.emit(active_area)
			await last_area.interact.call()
			can_interact = true
	pass

func _to_string() -> String:
	return "InteractionManager(active_area:{0}, active_areas:{1}, can_interact:{2})".format([active_area, str(active_areas), can_interact])
