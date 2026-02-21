extends Control
class_name UIInteractButton

@onready var anim: AnimationPlayer = $Anim
@export var button_text: String
@onready var text_label: Label = $HBoxContainer/Text
@onready var button: Panel = $HBoxContainer/Button

var is_hide: bool = true

func _ready() -> void:
	text_label.text = button_text
	button.visible = not Global.is_mobile_game
	pass

func show_button():
	if not is_hide: return
	anim.play("show")
	is_hide = false
	pass

func hide_button():
	if is_hide: return
	if anim.is_playing():
		await anim.animation_finished
	anim.play_backwards("show")
	is_hide = true
	pass

func pressed():
	anim.play("interact")
	await anim.animation_finished
	hide_button()
	pass

func reset():
	anim.play("RESET")
	is_hide = true
	pass
