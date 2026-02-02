extends CanvasLayer
class_name Mask

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mask: Sprite2D = $Mask
@onready var shake: AnimationPlayer = $Shake

func _ready() -> void:
	self.visible = false
	animation_player.animation_finished.connect(_on_break_finished)

func mask_break():
	self.visible = true
	var animation = "break_" + str(Global.broken_mask_score)
	animation_player.play(animation)
	shake.play("shake")
	
func _on_break_finished(_animation_name):
	await get_tree().create_timer(1).timeout
	self.visible = false
