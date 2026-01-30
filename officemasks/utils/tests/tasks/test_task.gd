extends Area2D

@export var task: Task

var is_player_inside: bool = false
@onready var interact_button: UIInteractButton = $UI/InteractButton

func on_task_completed():
	task.complete()
	pass

func start_task():
	await get_tree().create_timer(2.0)
	end_task()
	pass

func end_task():
	on_task_completed()
	monitoring = false
	pass

func _on_body_entered(body: Node2D) -> void:
	is_player_inside = true
	interact_button.show_button()
	pass # Replace with function body.

func _on_body_exited(body: Node2D) -> void:
	is_player_inside = false
	interact_button.hide_button()
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if task.is_completed(): return
	if event.is_action_pressed("interact") and is_player_inside:
		start_task()
	pass
