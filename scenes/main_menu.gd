extends Control


func _ready() -> void:
	$Music.play()
	var popup = $VBoxContainer/SelectButton.get_popup()
	popup.id_pressed.connect(level_menu)


# When the user clicks the start button
func _on_start_button_pressed() -> void:
	# Change the scene to the main scene
	# THIS WILL CHANGE WHEN WE HAVE LEVELS
	$Music.stop()
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
	Globals.can_attack = false
	Globals.can_dash = false
	Globals.max_jumps = 1
	Globals.checkpoint = null
	Globals.starting_pos = Vector2(893, 648)


# When the user clicks the quit button
func _on_quit_button_pressed() -> void:
	# Quiting out of the tree exits the game
	get_tree().quit()


func level_menu(id):
	$Music.stop()
	
	if id == 3:
		get_tree().change_scene_to_file("res://scenes/boss.tscn")
		return
	
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
	
	if id == 0: # Level 1
		Globals.starting_pos = Vector2(3154, -400)
		Globals.can_attack = true
	elif id == 1: # Level 2
		Globals.starting_pos = Vector2(176, -1916)
		Globals.can_attack = true
		Globals.max_jumps = 2
	elif id == 2: # Level 3
		Globals.starting_pos = Vector2(3836, -3692)
		Globals.can_attack = true
		Globals.can_dash = true
		Globals.max_jumps = 2
