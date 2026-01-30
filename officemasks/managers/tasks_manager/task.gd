extends Resource
class_name Task

enum State { NONE, INCOMPLETE, COMPLETE }

@export var task_name: String
@export var task_id: int
@export var state : State

signal completed

func complete():
	state = State.COMPLETE
	completed.emit(self)
	pass

func is_completed():
	return state == State.COMPLETE
