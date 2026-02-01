extends Control

@onready var credit_scene : Node = $"../CreditsScene"
@onready var contenedor_botones : Node = $ContenedorBotones
@onready var restart_popup : Node = $PopupRestart
@onready var quit_popup : Node = $PopupExit

var is_paused : bool = false

# SETUP
func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  # para que funcione en pausa

# ABRIR/CERRAR MENU
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if is_paused:
			visible = false
			contenedor_botones.visible = false
			get_tree().paused = false
			is_paused = false
		else: 
			visible = true
			quit_popup.visible = false
			restart_popup.visible = false
			contenedor_botones.visible = true
			get_tree().paused = true
			is_paused = true

# CONTINUAR
func _on_boton_continuar_pressed() -> void:
	contenedor_botones.visible = false
	get_tree().paused = false
	is_paused = false

# REINICIAR
func _on_boton_reiniciar_pressed() -> void:
	contenedor_botones.visible = false
	restart_popup.visible = true
	
func _on_popup_restart_cancel() -> void:
	restart_popup.visible = false
	contenedor_botones.visible = true
	
func _on_popup_restart_confirm() -> void:
	get_tree().paused = false
	Global._on_scene_changed(Global.Scenes.GAME)

# CREDITOS
func _on_boton_creditos_pressed() -> void:
	contenedor_botones.visible = false
	credit_scene.visible = true

# SALIR
func _on_boton_salir_pressed() -> void:
	contenedor_botones.visible = false
	quit_popup.visible = true

func _on_popup_exit_cancel() -> void:
	quit_popup.visible = false
	contenedor_botones.visible = true
	
func _on_popup_exit_confirm() -> void:
	get_tree().quit()
