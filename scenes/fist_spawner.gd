extends Node2D

@export var fist_scene: PackedScene  # Expose the fist scene in the Inspector
@export var spawn_interval: float = 1.5  # Time between fist spawns

var fist: Node2D = null  # Track the current fist instance

func _ready():
	start_spawning()

func start_spawning():
	while true:
		# Wait for the current fist to finish retracting
		if fist == null or not is_instance_valid(fist):
			spawn_fist()
		await get_tree().create_timer(spawn_interval).timeout

func spawn_fist():
	if fist_scene:
		fist = fist_scene.instantiate()  # Create a new instance of the fist scene
		add_child(fist)  # Add the fist to the scene tree
		fist.add_to_group("boss")
	else:
		print("fist_scene is not assigned!")
