extends Area2D




func _on_body_entered(_body: Node2D) -> void:
	Globals.score += 100
	queue_free()
