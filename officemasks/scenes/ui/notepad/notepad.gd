extends Control
@onready var tasks: VBoxContainer = $Pivot/Notepad/Texture/Tasks

const notepad_task_scene = preload("res://scenes/ui/notepad/notepad_task.tscn")
@onready var anim: AnimationPlayer = $Anim
@onready var sound: AudioStreamPlayer = $Sound

var is_open: bool = false
var enabled: bool = true

func _ready() -> void:
	for task in TasksManager.tasks:
		var notepad_task: NotepadTask = notepad_task_scene.instantiate()
		tasks.add_child(notepad_task)
		notepad_task.set_task(task)
	TasksManager.all_completed.connect(on_tasks_completed)
	pass

func on_tasks_completed():
	enabled = false
	if is_open:
		close()
	pass

func _input(event: InputEvent) -> void:
	if not enabled: return
	if anim.is_playing(): return
	if event.is_action_pressed("open_tasks"):
		if not is_open:
			open()
		else:
			close()
	pass

func open():
	sound.play()
	anim.play("show")
	is_open = true
	get_tree().call_group("PlayerCamera", "on_notepad_open")
	pass

func close():
	sound.play()
	anim.play_backwards("show")
	is_open = false
	get_tree().call_group("PlayerCamera", "on_notepad_close")
	pass
