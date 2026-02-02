extends Node

@export var tasks: Array[Task]

signal task_completed(task: Task)

signal all_completed
var counter: int = 0

func _ready() -> void:
	for task in tasks:
		task.completed.connect(on_task_completed)
	pass

func on_task_completed(task: Task):
	task_completed.emit(task)
	counter += 1
	if counter == Global.MAX_BROKEN_SCORE:
		all_completed.emit()
	pass

func trigger_all_completed():
	all_completed.emit()
	pass
