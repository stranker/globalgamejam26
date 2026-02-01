extends Control

@onready var credit_scene : Node = $CreditsScene
@onready var quit_popup : Node = $Popup
@onready var contenedor_botones : Node = $ContenedorBotones

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		contenedor_botones.visible = true
		quit_popup.visible = false

func _on_boton_jugar_pressed() -> void:
	Global._on_scene_changed(Global.Scenes.GAME)

func _on_boton_creditos_pressed() -> void:
	contenedor_botones.visible = false
	credit_scene.visible = true

func _on_boton_salir_pressed() -> void:
	contenedor_botones.visible = false
	quit_popup.visible = true

func _on_popup_confirm() -> void:
	get_tree().quit()

func _on_popup_cancel() -> void:
	quit_popup.visible = false
	contenedor_botones.visible = true
