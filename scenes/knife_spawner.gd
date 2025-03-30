extends Node2D

@export var butcher_knife_scene: PackedScene  # Reference to the ButcherKnife scene
@export var spawn_interval: float = .8  # Time between knife spawns

func start_spawning():
	while true:
		spawn_knife()
		await get_tree().create_timer(spawn_interval).timeout

func spawn_knife():
	if butcher_knife_scene:
		var knife = butcher_knife_scene.instantiate()
		add_child(knife)
		
		# Set a random spawn position at the top of the screen
		knife.position = Vector2(randf_range(100, 900), -50)

	else:
		print("ButcherKnife scene is not assigned!")
