extends Control


# When the user clicks the start button
func _on_start_button_pressed() -> void:
	# Change the scene to the main scene
	# THIS WILL CHANGE WHEN WE HAVE LEVELS
	get_tree().change_scene_to_file("res://scenes/main.tscn")


# When the user clicks the quit button
func _on_quit_button_pressed() -> void:
	# Quiting out of the tree exits the game
	get_tree().quit()
