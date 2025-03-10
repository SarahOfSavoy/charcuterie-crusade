extends Area2D

signal pepper_collected

func _on_body_entered(_body: Node2D) -> void:
	pepper_collected.emit()
	queue_free()
