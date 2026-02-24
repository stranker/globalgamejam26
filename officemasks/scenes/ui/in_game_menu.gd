extends Control

var is_paused : bool = false
@onready var anim: AnimationPlayer = $Anim
@onready var click_sound: AudioStreamPlayer = $ClickSound
@onready var boton_salir: Button = $ContenedorBotones/BotonSalir

signal game_paused(paused: bool)

func _ready() -> void:
	game_paused.connect(Global.on_game_paused)
	boton_salir.visible = not Global.is_web_game
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if is_paused:
			unpause_menu()
			anim.play_backwards("show_menu")
			await anim.animation_finished
			anim.play("RESET")
		else:
			pause_menu()
			anim.play("show_menu")

func pause_menu():
	click_sound.play()
	is_paused = true
	game_paused.emit(is_paused)
	get_tree().paused = is_paused
	pass

func unpause_menu():
	click_sound.play()
	is_paused = false
	game_paused.emit(false)
	get_tree().paused = is_paused
	anim.play("RESET")
	pass

# CONTINUAR
func _on_boton_continuar_pressed() -> void:
	click_sound.play()
	anim.play_backwards("show_menu")
	unpause_menu()

# REINICIAR
func _on_boton_reiniciar_pressed() -> void:
	if anim.is_playing():
		await anim.animation_finished
	click_sound.play()
	anim.play("show_popup_restart")
	pass
	
func _on_popup_restart_cancel() -> void:
	click_sound.play()
	anim.play("idle")
	pass

func _on_popup_restart_confirm() -> void:
	click_sound.play()
	unpause_menu()
	Global._on_scene_changed(Global.Scenes.GAME)
	pass

# CREDITOS
func _on_boton_creditos_pressed() -> void:
	click_sound.play()
	anim.play("show_credits")
	pass

# SALIR
func _on_boton_salir_pressed() -> void:
	click_sound.play()
	anim.play("show_popup_exit")
	pass

func _on_popup_exit_cancel() -> void:
	click_sound.play()
	anim.play("idle")
	pass

func _on_popup_exit_confirm() -> void:
	click_sound.play()
	get_tree().quit()


func _on_back_button_button_down() -> void:
	click_sound.play()
	anim.play("idle")
	pass # Replace with function body.


func _on_play_button_button_down() -> void:
	click_sound.play()
	Global._on_scene_changed(Global.Scenes.GAME)
	pass # Replace with function body.


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	pass # Replace with function body.


func _on_opciones_button_down() -> void:
	click_sound.play()
	anim.play("show_options")
	pass # Replace with function body.


func _on_back_options_button_down() -> void:
	click_sound.play()
	anim.play("idle")
	pass # Replace with function body.
