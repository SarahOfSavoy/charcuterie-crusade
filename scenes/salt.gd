extends Area2D

signal salt_collected

func _on_body_entered(_body: Node2D) -> void:
	salt_collected.emit()
	queue_free()
	
