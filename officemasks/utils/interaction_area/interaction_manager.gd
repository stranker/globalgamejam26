extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var label: Label = $Label

const base_text = "[E] para "

var active_areas = []
var can_interact : bool = true

func register_area(area : InteractionArea):
	active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
	
func _process(_delta: float) -> void:
	
	# finding the closes interactable area and setting up the hint text
	
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		var current_area = active_areas[0]
		label.text = base_text + current_area.action_name
		label.global_position = current_area.global_position
		label.global_position.y -= 72
		label.global_position.x -= label.size.x / 2
		label.show()
	else:
		label.hide()
		

# Custom sort for finding the closest area to the player
func _sort_by_distance_to_player(area_1, area_2):
	var area1_to_player = player.global_position.distance_to(area_1.global_position)
	var area2_to_player = player.global_position.distance_to(area_2.global_position)
	return area1_to_player < area2_to_player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0 :
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
