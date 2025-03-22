extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Level End Screen/Score Label".text = "Score: " + str(Globals.score)


# When the restart button is pressed
func _on_restart_pressed() -> void:
	Globals.is_paused = false
	Globals.score = Globals.checkpoint.score
	var player = get_parent().get_parent()
	player.take_damage(Globals.health - 100)
	player.position = Globals.checkpoint.position
	queue_free()


# When the continue button is pressed
func _on_continue_pressed() -> void:
	get_tree().quit()
