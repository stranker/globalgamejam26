extends Control

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  # para que funcione en pausa

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		visible = false
