extends Resource
class_name Task

enum State { NONE, INCOMPLETE, COMPLETE }

@export var task_name: String
@export var task_id: TasksManager.TaskCharacterId
@export var state : State

signal completed

func complete():
	state = State.COMPLETE
	completed.emit(self)
	pass

func is_completed():
	return state == State.COMPLETE

func reset():
	state = State.NONE
	pass
