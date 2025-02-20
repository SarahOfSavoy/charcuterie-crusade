extends Area2D




func _on_body_entered(body: Node2D) -> void:
	HUD.score += 100
	queue_free()
