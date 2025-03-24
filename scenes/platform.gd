extends StaticBody2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_down"):
		collision_layer = 2
		await get_tree().create_timer(0.1).timeout
		collision_layer = 1
