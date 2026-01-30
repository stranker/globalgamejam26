extends Node

@export var tasks: Array[Task]

signal task_completed(task: Task)

func _ready() -> void:
	for task in tasks:
		task.completed.connect(on_task_completed)
	pass

func on_task_completed(task: Task):
	task_completed.emit(task)
	pass
