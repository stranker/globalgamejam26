extends Camera2D

signal target_reached

@export var zoom_into_target: Vector2 = Vector2(2.4, 2.4)
@export var zoom_default: Vector2 = Vector2(2, 2)

var player_camera: Camera2D

func _ready() -> void:
	player_camera = get_viewport().get_camera_2d()
	pass

func target_from_position(pos: Vector2, target: Node2D, reach_time):
	global_position = pos
	target_node(target, reach_time)
	pass

func _physics_process(delta: float) -> void:
	global_position = player_camera.global_position
	pass

func target_node(target: Node2D, reach_time: float):
	set_physics_process(false)
	player_camera.enabled = false
	enabled = true
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "global_position", target.global_position, reach_time).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "zoom", zoom_into_target, reach_time).set_ease(Tween.EASE_IN)
	tween.play()
	await tween.finished
	target_reached.emit()
	pass

func reset():
	target_from_position(global_position, get_tree().get_first_node_in_group("Player"), 0.2)
	await target_reached
	player_camera.enabled = true
	enabled = false
	set_physics_process(true)
	pass
