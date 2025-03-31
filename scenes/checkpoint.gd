extends Area2D

var score = 0

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		Globals.checkpoint = self
		score = Globals.score
		print("Checkpoint saved at:", global_position)
