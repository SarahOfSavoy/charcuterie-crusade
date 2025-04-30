extends Node2D

func killed_boss():
	await get_tree().create_timer(3.0).timeout
	
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
