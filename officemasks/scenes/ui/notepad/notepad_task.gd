extends Control
class_name NotepadTask

@onready var anim: AnimationPlayer = $Anim
@onready var label: Label = $MarginContainer/HBoxContainer/Label

var task_ref: Task

func set_task(task: Task):
	task_ref = task
	task.completed.connect(on_task_completed)
	label.text = task.task_name
	pass

func on_task_completed(task: Task):
	anim.play("completed")
	pass
