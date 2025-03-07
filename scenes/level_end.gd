extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Level End Screen/Score Label".text = "Score: " + str(Globals.score)


# When the restart button is pressed
func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
	Globals.is_paused = false
	Globals.score = 0


# When the continue button is pressed
func _on_continue_pressed() -> void:
	get_tree().quit()
