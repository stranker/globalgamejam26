extends CanvasLayer

@onready var pivot: Control = $Pivot
@onready var anim: AnimationPlayer = $Anim
@export var debug: bool = false
@export var intensity: float = 2
@onready var particles: CPUParticles2D = $Pivot/Particles
@onready var break_sfx: AudioStreamPlayer = $Pivot/Break

var pivot_initial_pos: Vector2
var counter: int = 0

signal start_mask_break
signal end_mask_break

func _ready() -> void:
	set_physics_process(false)
	pivot_initial_pos = pivot.global_position
	start_mask_break.connect(Global.on_start_mask_break)
	end_mask_break.connect(Global.on_end_mask_break)
	pass

func _physics_process(delta: float) -> void:
	var intense: float = counter * intensity
	var new_pos: Vector2 = pivot_initial_pos + Vector2(randf_range(-intense,intense),randf_range(-intense,intense))
	pivot.global_position = Vector2(new_pos)
	pass

func anim_break_mask():
	set_physics_process(false)
	pivot.global_position = pivot_initial_pos
	particles.emitting = true
	start_mask_break.emit()
	pass

func mask_break():
	var tween: Tween = create_tween()
	tween.tween_property(pivot, "modulate:a", 1, 0.2).set_ease(Tween.EASE_IN)
	tween.play()
	var animation: String
	if debug:
		animation = "break_" + str(counter)
	else:
		counter = Global.broken_mask_score
		animation = "break_" + str(Global.broken_mask_score)
	anim.play(animation)
	set_physics_process(true)
	break_sfx.play()
	pass


func _on_anim_animation_finished(anim_name: StringName) -> void:
	await get_tree().create_timer(0.5).timeout
	var tween: Tween = create_tween()
	tween.tween_property(pivot, "modulate:a", 0, 0.2).set_ease(Tween.EASE_IN)
	tween.play()
	end_mask_break.emit()
	pass # Replace with function body.
