extends Control
class_name MobileInput

@onready var touch_screen_joystick: TouchScreenJoystick = $TouchScreenJoystick
@onready var interact_button: TextureButton = $InteractButton
@onready var interact_icon: TextureRect = $InteractButton/Icon

const ACTION_ICON: Texture = preload("uid://b3gd05cc8hnro")
const DIALOG_ICON: Texture = preload("uid://dab07jmiylb1w")

func _ready() -> void:
	InteractionManager.active_area_updated.connect(on_active_area_updated)
	InteractionManager.interact_entered.connect(on_interact_entered)
	InteractionManager.interact_empty.connect(on_interact_empty)
	interact_icon.texture = DIALOG_ICON
	interact_button.hide()
	pass

func _on_interact_button_button_down() -> void:
	var interact_event = InputEventAction.new()
	interact_event.action = "interact"
	interact_event.pressed = true
	Input.parse_input_event(interact_event)
	pass # Replace with function body.

func on_active_area_updated(area: InteractionArea):
	interact_icon.texture = DIALOG_ICON if area.type == area.Type.DIALOG else ACTION_ICON
	pass

func on_interact_entered():
	interact_button.show()
	pass

func on_interact_empty():
	interact_button.hide()
	pass
