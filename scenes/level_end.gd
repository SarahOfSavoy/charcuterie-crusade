extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Level End Screen/Score Label".text = "Score: " + str(Globals.score)

# When the restart button is pressed
func _on_restart_pressed() -> void:
	Globals.is_paused = false
	
	# Get current scene path
	var current_scene = get_tree().current_scene.scene_file_path
	
	# Only restore checkpoint data if in tutorial
	if "tutorial" in current_scene.to_lower():
		Globals.score = Globals.checkpoint.score
		var player = get_parent().get_parent()
		player.health = 100  # Fully heal the player
		player.position = Globals.checkpoint.position
	
	# Reload the current scene to reset everything
	get_tree().reload_current_scene()
	queue_free()

# When the continue button is pressed
func _on_continue_pressed() -> void:
	get_tree().quit()
