extends Control

var is_paused : bool = false
@onready var anim: AnimationPlayer = $Anim
@onready var menu_music: AudioStream = preload("res://utils/music/826622__xkeril__memories-of-a-sweet-summer-music-loop.wav")

func _ready() -> void:
	anim.play("idle")
	Global.play_music(menu_music)
	pass

func pause_menu():
	is_paused = true
	get_tree().paused = is_paused
	pass

func unpause_menu():
	is_paused = false
	get_tree().paused = is_paused
	pass

# CONTINUAR
func _on_boton_continuar_pressed() -> void:
	anim.play_backwards("show_menu")
	unpause_menu()

# REINICIAR
func _on_boton_reiniciar_pressed() -> void:
	if anim.is_playing():
		await anim.animation_finished
	anim.play("show_popup_restart")
	pass
	
func _on_popup_restart_cancel() -> void:
	anim.play("idle")
	pass

func _on_popup_restart_confirm() -> void:
	unpause_menu()
	Global._on_scene_changed(Global.Scenes.GAME)
	pass

# CREDITOS
func _on_boton_creditos_pressed() -> void:
	anim.play("show_credits")
	pass

# SALIR
func _on_boton_salir_pressed() -> void:
	anim.play("show_popup_exit")
	pass

func _on_popup_exit_cancel() -> void:
	anim.play("idle")
	pass

func _on_popup_exit_confirm() -> void:
	get_tree().quit()


func _on_back_button_button_down() -> void:
	anim.play("idle")
	pass # Replace with function body.


func _on_play_button_button_down() -> void:
	Global._on_scene_changed(Global.Scenes.GAME)
	pass # Replace with function body.
