extends Node

var is_player_in_end_area = false

func _ready() -> void:
	$LevelMusic.play()
	$Player.position = Globals.starting_pos
	$Player.max_jumps = Globals.max_jumps
	$Player.can_attack = Globals.can_attack
	$Player.can_dash = Globals.can_dash

func _on_level_end_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_player_in_end_area = true

func _on_level_end_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_player_in_end_area = false

func _input(event: InputEvent) -> void:
	if is_player_in_end_area and event.is_action_pressed("attack"):
		get_tree().change_scene_to_file("res://scenes/boss.tscn")
