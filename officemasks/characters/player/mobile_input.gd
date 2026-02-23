extends Control
class_name MobileInput

#@onready var touch_screen_joystick: TouchScreenJoystick = $TouchScreenJoystick
@onready var interact_button: TextureButton = $InteractButton
@onready var interact_icon: TextureRect = $InteractButton/Icon
@onready var joystick_controller: Node2D = $JoystickController
@onready var tasks_button: TextureButton = $TasksButton

const ACTION_ICON: Texture = preload("uid://b3gd05cc8hnro")
const DIALOG_ICON: Texture = preload("uid://dab07jmiylb1w")

var enabled: bool = false

func _ready() -> void:
	enabled = Global.is_mobile_game
	InteractionManager.active_area_updated.connect(on_active_area_updated)
	InteractionManager.interact_entered.connect(on_interact_entered)
	InteractionManager.interact_empty.connect(on_interact_empty)
	MinigamesManager.click_point_start.connect(on_click_point_start)
	Global.game_paused.connect(on_game_paused)
	interact_icon.texture = DIALOG_ICON
	interact_button.hide()
	joystick_controller.visible = enabled
	joystick_controller.enabled = enabled
	tasks_button.visible = enabled
	pass

func _on_interact_button_button_down() -> void:
	if not enabled: return
	var interact_event = InputEventAction.new()
	interact_event.action = "interact"
	interact_event.pressed = true
	Input.parse_input_event(interact_event)
	pass # Replace with function body.

func on_active_area_updated(area: InteractionArea):
	interact_icon.texture = DIALOG_ICON if area.type == area.Type.DIALOG else ACTION_ICON
	pass

func on_interact_entered():
	if not enabled: return
	interact_button.show()
	pass

func on_interact_empty():
	if not enabled: return
	interact_button.hide()
	pass


func _on_player_state_changed(state: Player.State) -> void:
	if not enabled: return
	match state:
		Player.State.INTERACT:
			hide()
		_:
			show()
	pass # Replace with function body.


func _on_tasks_button_button_down() -> void:
	if not enabled: return
	var interact_event = InputEventAction.new()
	interact_event.action = "open_tasks"
	interact_event.pressed = true
	Input.parse_input_event(interact_event)
	pass # Replace with function body.


func _on_options_button_button_down() -> void:
	if not enabled: return
	var interact_event = InputEventAction.new()
	interact_event.action = "escape"
	interact_event.pressed = true
	Input.parse_input_event(interact_event)
	pass # Replace with function body.

func on_game_paused(is_paused: bool):
	visible = not is_paused
	pass

func on_click_point_start():
	hide()
	pass
