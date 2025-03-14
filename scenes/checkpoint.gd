extends Area2D

# Current save state score
var score = 0

func _on_body_entered(body: Node2D) -> void:
	Globals.checkpoint = self
	score = Globals.score
