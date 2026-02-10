extends Node

@export var tasks: Array[Task]

signal task_completed(task: Task)

enum TaskCharacterId { NONE, ANGELICA, LEANDRO, FRANCESCA }

signal all_completed
var counter: int = 0

func tasks_completed():
	return counter == tasks.size() - 1

func _ready() -> void:
	await get_tree().process_frame
	for task in tasks:
		task.completed.connect(on_task_completed)
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_1 and event.pressed:
			trigger_all_completed()

func on_task_completed(task: Task):
	task_completed.emit(task)
	counter += 1
	if counter == Global.MAX_BROKEN_SCORE:
		all_completed.emit()
		get_tree().create_timer(2).timeout
	pass

func trigger_all_completed():
	all_completed.emit()
	pass

func set_task_completed(task_id: int):
	for task in tasks:
		if task.task_id == task_id:
			task.complete()
			break
	pass
