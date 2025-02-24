extends CanvasLayer

@onready var scoreLabel = get_node("Score")

# Repeatedly update the state of the player (score and health)
func _process(_delta: float) -> void:
	if scoreLabel != null:
		update_score(Globals.score)

# Change the score text with a new score
func update_score(new_score):
	scoreLabel.text = "Score: " + str(new_score)
