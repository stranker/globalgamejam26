extends Control
class_name ConnectGridGameScene

@onready var connect_grid: ConnectGrid = $Panel/GamePivot/ConnectGrid
@onready var tries_label: Label = $Panel/Tries
@export var tries: int
@onready var reset_button: Button = $Panel/Reset

signal win()
signal lose()
signal end_game()

func _ready() -> void:
	tries_label.text = "Tries:" + str(tries)
	connect_grid.game_win.connect(on_game_win)
	pass

func _on_reset_button_down() -> void:
	tries -= 1
	update_tries_label()
	if tries > 0:
		connect_grid.reset_game()
	else:
		lose.emit()
		end_game.emit()
	pass # Replace with function body.

func update_tries_label():
	tries_label.text = "Tries:" + str(tries)
	pass

func on_game_win():
	win.emit()
	reset_button.hide()
	end_game.emit()
	pass
