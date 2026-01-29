extends Area2D
class_name ProximityAreaComponent

signal player_entered
signal player_exited


func _on_body_entered(body: Node2D) -> void:
	player_entered.emit()
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	player_exited.emit()
	pass # Replace with function body.
