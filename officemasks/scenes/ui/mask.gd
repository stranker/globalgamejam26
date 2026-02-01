extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	self.visible = false
	animation_player.animation_finished.connect(_on_break_finished)

func mask_break():
	self.visible = true
	var animation = "break_" + str(Global.broken_mask_score)
	animation_player.play(animation)
	
func _on_break_finished(_animation_name):
	self.visible = false
