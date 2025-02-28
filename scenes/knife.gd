extends Area2D

signal knife_collected

func _on_body_entered(_body: Node2D) -> void:
	knife_collected.emit()
	queue_free()
