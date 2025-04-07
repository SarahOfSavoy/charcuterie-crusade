extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LevelMusic.play()
	$Player.position = Globals.starting_pos
	$Player.max_jumps = Globals.max_jumps
	$Player.can_attack = Globals.can_attack
	$Player.can_dash = Globals.can_dash


# When the player finishes the tutorial
func _on_level_end_area_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/boss.tscn")
