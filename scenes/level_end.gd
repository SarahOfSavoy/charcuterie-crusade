extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Level End Screen/Score Label".text = "Score: " + str(Globals.score)

func is_boss_level() -> bool:
	return get_tree().current_scene.name == "BossLevel"

# When the restart button is pressed
func _on_restart_pressed() -> void:
	Globals.is_paused = false
	print(is_boss_level())
	if is_boss_level():
		print("Restarting boss level from beginning.")
		# Don't use checkpoint — just reload the scene
		get_tree().reload_current_scene()
	else:
		# Standard level: reset to checkpoint
		if Globals.checkpoint != null:
			Globals.score = Globals.checkpoint.score
			var player = get_parent().get_parent()
			player.take_damage(Globals.health - 100)
			player.position = Globals.checkpoint.position

	queue_free()
	
# When the continue button is pressed
func _on_continue_pressed() -> void:
	get_tree().quit()
