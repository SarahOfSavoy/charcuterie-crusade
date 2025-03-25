extends Node2D

@export var fist_scene: PackedScene  # Fist scene to spawn
@export var spawn_interval: float = 1.5  # Time between spawns
@export var max_health: int = 100  # Shared boss health
@export var health_bar: ProgressBar  # Health bar reference (now under BossSpawner)

var current_health: int = max_health  # Track persistent boss health
var fist: Node2D = null  # Track the current fist instance

func _ready():
	update_health_bar()  # Set health bar to full at start
	start_spawning()

func start_spawning():
	while current_health > 0:  # Stop spawning if the boss dies
		if fist == null or not is_instance_valid(fist):
			spawn_fist()
		await get_tree().create_timer(spawn_interval).timeout

func spawn_fist():
	if fist_scene:
		fist = fist_scene.instantiate()
		add_child(fist)
		fist.add_to_group("boss")

		# Pass current health to the new fist
		fist.current_health = current_health
		fist.max_health = max_health

		# Connect damage signal if not already connected
		if not fist.is_connected("boss_damaged", Callable(self, "_on_boss_damaged")):
			fist.connect("boss_damaged", Callable(self, "_on_boss_damaged"))
	else:
		print("Error: Fist scene is not assigned!")

func _on_boss_damaged(damage: int):
	current_health -= damage
	current_health = max(current_health, 0)  # Ensure it never goes negative

	update_health_bar()

	if current_health <= 0:
		print("Boss defeated")
		queue_free()  # Stop spawning fists

func update_health_bar():
	if health_bar:
		var health_percentage = (float(current_health) / max_health) * 100
		print(health_percentage)
		health_bar.value = health_percentage
