@tool
extends Node2D
class_name ConnectGrid

enum State { IDLE, CONNECTING, END_CONNECT }
var state: State = State.IDLE

@onready var grid: Node2D = $Grid
@onready var lines: Node2D = $Lines
@onready var neurons: CPUParticles2D = $Brain/Polygon2D/Neurons
@onready var brain_lines_anim: AnimationPlayer = $Brain/Polygon2D/BrainLines/Anim
@onready var neurons_explosion: CPUParticles2D = $Brain/Polygon2D/NeuronsExplosion

@export var grid_colors: Array[Color]
@export var neurons_base_amount:int = 20
@export var neurons_per_color_completed:int = 20:
	set(amount):
		neurons_per_color_completed = amount
		if neurons:
			neurons.amount = neurons_base_amount + amount
@export var brain_lines_speed_increment_per_color_completed:float = 0.1

signal release_connecting

var start_cell: ConnectGridCell
var end_cell: ConnectGridCell
var current_cell: ConnectGridCell
var current_line: Line2D
var current_cells_connecting: Array[ConnectGridCell]
var cells_connected: Array[ConnectGridCell]

signal game_win()

func _ready() -> void:
	on_idle_state()
	for i in range(grid.get_child_count()):
		var grid_cell: ConnectGridCell = grid.get_child(i) as ConnectGridCell
		release_connecting.connect(grid_cell.on_grid_release_connecting)
		grid_cell.touched.connect(on_grid_cell_touched.bind(grid_cell))
		grid_cell.released.connect(on_grid_cell_released.bind(grid_cell))
		grid_cell.set_id(i)
		grid_cell.grid_colors = grid_colors
		grid_cell.reset()
	pass

func set_state(new_state: State):
	if state == new_state: return
	state = new_state
	match state:
		State.IDLE:
			on_idle_state()
		State.CONNECTING:
			on_connecting_state()
		State.END_CONNECT:
			on_end_connect_state()
	pass

func on_idle_state():
	start_cell = null
	end_cell = null
	pass

func on_connecting_state():
	current_line = Line2D.new()
	lines.add_child(current_line)
	for cell: ConnectGridCell in grid.get_children():
		cell.close()
	pass

func on_end_connect_state():
	if cells_connected.size() == grid.get_child_count():
		print("GANASTE")
		game_win.emit()
	set_state(State.IDLE)
	pass

func on_grid_cell_touched(grid_cell: ConnectGridCell):
	match state:
		State.IDLE:
			set_state(State.CONNECTING)
			start_cell = grid_cell
			current_line.default_color = grid_cell.circle.modulate
			process_grid_cell(grid_cell)
		State.CONNECTING:
			process_grid_cell(grid_cell)
			if start_cell.id != grid_cell.id and start_cell.cell_color == grid_cell.cell_color:
				connect_current_cells()
				reset_to_end()
	pass

func process_grid_cell(grid_cell: ConnectGridCell):
	if current_cell:
		current_cell.close_neighbours()
	current_cell = grid_cell
	current_cell.open_neighbours(start_cell)
	current_cells_connecting.append(grid_cell)
	current_line.add_point(grid_cell.position)
	pass

func on_grid_cell_released(grid_cell: ConnectGridCell):
	match state:
		State.CONNECTING:
			end_cell = grid_cell
			current_line.add_point(grid_cell.position)
			process_release()
	pass

func process_release():
	if start_cell.id != end_cell.id and start_cell.cell_color == end_cell.cell_color:
		connect_current_cells()
	else:
		current_line.queue_free()
	reset_to_end()
	pass

func connect_current_cells():
	for cell: ConnectGridCell in current_cells_connecting:
		cell.set_connected()
		cells_connected.append(cell)
	neurons.amount += neurons_per_color_completed
	brain_lines_anim.speed_scale += brain_lines_speed_increment_per_color_completed
	neurons_explosion.restart()
	pass

func reset_connecting():
	for cell: ConnectGridCell in grid.get_children():
		cell.reset_connecting()
	pass

func reset_to_end():
	reset_connecting()
	current_cells_connecting.clear()
	set_state(State.END_CONNECT)
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if start_cell and not current_cell:
				reset_to_end()
			if start_cell and current_cell:
				if start_cell.cell_color != current_cell.cell_color or start_cell == current_cell:
					current_line.queue_free()
					reset_to_end()
	pass

func reset_game():
	for cell: ConnectGridCell in grid.get_children():
		cell.reset()
	for line in lines.get_children():
		line.queue_free()
	cells_connected.clear()
	pass
