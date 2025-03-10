extends Area2D


# When the player lands in the spikes
func _on_body_entered(body: Node2D) -> void:
	# Chack that the body is the player and deal full damage
	if body is Player:
		body.take_damage(50)
