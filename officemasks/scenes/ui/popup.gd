extends Control
signal confirm
signal cancel

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  # para que funcione en pausa

func _on_yes_button_pressed() -> void:
	confirm.emit()

func _on_no_button_pressed() -> void:
	cancel.emit()
