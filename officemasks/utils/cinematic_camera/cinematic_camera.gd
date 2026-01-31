extends Camera2D

signal target_reached

@export var zoom_into_target: Vector2 = Vector2(2.4, 2.4)
@export var zoom_default: Vector2 = Vector2(2, 2)

var current_camera: Camera2D

func target_node(target: Node2D, reach_time: float):
	current_camera = get_viewport().get_camera_2d()
	current_camera.enabled = false
	global_position = current_camera.global_position
	zoom = current_camera.zoom
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
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "global_position", current_camera.global_position, 0.2).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "zoom", zoom_into_target, 0.2).set_ease(Tween.EASE_IN)
	tween.play()
	enabled = false
	current_camera.enabled = true
	pass
