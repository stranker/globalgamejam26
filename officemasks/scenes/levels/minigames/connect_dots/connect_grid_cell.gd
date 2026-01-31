@tool
extends Area2D
class_name ConnectGridCell

enum CellColor { NONE, RED, BLUE, GREEN, YELLOW }
enum State { IDLE, CONNECTING, CONNECTED }

signal touched()
signal released()

var grid_colors: Array[Color]

@export var id: int = -1
@export var cell_color : CellColor:
	set(new_color):
		if circle:
			circle.modulate = get_parent().get_parent().grid_colors[new_color]
			circle.visible = new_color != CellColor.NONE
		cell_color = new_color
		name = CellColor.keys()[new_color]
@onready var anim: AnimationPlayer = $Anim
@onready var debug_id: Label = $Debug/DebugId
@onready var debug_state: ColorRect = $Debug/DebugState
@onready var debug_available: ColorRect = $Debug/DebugAvailable
@onready var circle: Sprite2D = $Circle/Sprite

var state: State = State.IDLE

var is_available: bool = false

var neighbours: Array[ConnectGridCell]

func _ready() -> void:
	await get_tree().process_frame
	circle.modulate = get_parent().get_parent().grid_colors[cell_color]
	circle.visible = is_colored_cell() 
	name = CellColor.keys()[cell_color]
	set_available(is_colored_cell())
	pass

func set_state(new_state: State):
	if state == new_state: return
	state = new_state
	match state:
		State.IDLE:
			on_idle_state()
		State.CONNECTING:
			on_connecting_state()
		State.CONNECTED:
			on_connected_state()
	pass

func on_idle_state():
	debug_state.color = Color.WHITE
	anim.play("idle")
	set_available(cell_color != CellColor.NONE)
	pass

func on_connecting_state():
	debug_state.color = Color.BLUE
	anim.play("touched")
	touched.emit()
	pass

func on_connected_state():
	debug_state.color = Color.YELLOW
	pass

func set_id(new_id: int):
	id = new_id
	debug_id.text = "Id:" + str(id)
	pass

func set_available(value: bool):
	is_available = value
	debug_available.color = Color.GREEN if is_available else Color.RED
	pass

func set_connected():
	set_state(State.CONNECTED)
	pass

func reset():
	set_state(State.IDLE)
	set_available(is_colored_cell())
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	match state:
		State.IDLE:
			if not is_available:
				return
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
					set_state(State.CONNECTING)
			if event is InputEventMouseMotion:
				if event.button_mask == MOUSE_BUTTON_LEFT:
					set_state(State.CONNECTING)
		State.CONNECTING:
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
					released.emit()
					print_debug("RELEASED")
	pass # Replace with function body.

func is_colored_cell():
	return cell_color != CellColor.NONE

func _on_area_entered(area: Area2D) -> void:
	if neighbours.has(area): return
	neighbours.append(area)
	pass # Replace with function body.


func open_neighbours(start_cell: ConnectGridCell):
	for neighbour in neighbours:
		neighbour.open(start_cell)
	pass

func close_neighbours():
	for neighbour in neighbours:
		neighbour.close()
	pass

func open(start_cell: ConnectGridCell):
	match state:
		State.IDLE:
			if is_colored_cell() and start_cell.cell_color != cell_color:
				set_available(false)
			else:
				set_available(true)
	pass

func close():
	set_available(false)
	pass

func on_grid_release_connecting():
	if is_colored_cell():
		set_available(true)
	pass

func reset_connecting():
	if state == State.CONNECTED: return
	set_state(State.IDLE)
	set_available(is_colored_cell())
	pass

func _to_string() -> String:
	return "GridCell(id:{0}, color:{1})".format([id, cell_color])
