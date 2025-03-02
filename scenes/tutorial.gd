extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LevelMusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# When the player finishes the tutorial
func _on_level_end_area_body_entered(body: Node2D) -> void:
	Globals.is_paused = true
	var level_end = load("res://scenes/level_end.tscn").instantiate()
	$Player/Camera2D.add_child(level_end)	
