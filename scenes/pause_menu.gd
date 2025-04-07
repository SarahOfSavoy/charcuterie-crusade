extends CanvasLayer

func _on_resume_pressed() -> void:
	visible = false
	Engine.time_scale = 1


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	Engine.time_scale = 1


func _on_quit_pressed() -> void:
	get_tree().quit()
