extends Area2D

func _on_body_entered(body) -> void:
	if body.name == "Player":
		hide()
		body.heal(5)
		body.collect_coin()
		for i in range(100):
			Globals.score += 1
			await get_tree().create_timer(0.001).timeout
		queue_free()
