extends NPC

func _ready() -> void:
	super._ready()
	Global.coffe_done.connect(on_coffe_done)
	pass

func on_coffe_done(diff: MinigamesManager.GameType):
	interaction_area.monitoring = true
	next_dialogue = dialogue_a if diff == MinigamesManager.GameType.EASY else dialogue_b
	pass
