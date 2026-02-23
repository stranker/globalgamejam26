extends Control
@onready var tasks: VBoxContainer = $Pivot/Notepad/Texture/Tasks

const notepad_task_scene = preload("res://scenes/ui/notepad/notepad_task.tscn")
@onready var anim: AnimationPlayer = $Anim

var is_open: bool = false

func _ready() -> void:
	for task in TasksManager.tasks:
		var notepad_task: NotepadTask = notepad_task_scene.instantiate()
		tasks.add_child(notepad_task)
		notepad_task.set_task(task)
	pass

func _input(event: InputEvent) -> void:
	if anim.is_playing(): return
	if event.is_action_pressed("open_tasks"):
		if not is_open:
			anim.play("show")
			is_open = true
			get_tree().call_group("PlayerCamera", "on_notepad_open")
		else:
			anim.play_backwards("show")
			is_open = false
			get_tree().call_group("PlayerCamera", "on_notepad_close")
