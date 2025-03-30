extends Node2D

@export var fist_scene: PackedScene
@export var initial_spawn_interval: float = 1.5
@export var phase2_spawn_interval: float = 0.9  # 40% faster than initial
@export var initial_fist_speed: float = 500.0
@export var phase2_fist_speed: float = 675.0   # 50% faster than initial
@export var max_health: int = 100
@export var health_bar: ProgressBar
@export var hits_to_phase2: int = 10

var current_spawn_interval: float
var current_fist_speed: float
var current_health: int
var current_hits: int = 0
var is_phase2: bool = false
var fist: Node2D = null

func _ready():
	current_spawn_interval = initial_spawn_interval
	current_fist_speed = initial_fist_speed
	current_health = max_health
	update_health_bar()
	start_spawning()

func start_spawning():
	while current_health > 0:
		if fist == null or not is_instance_valid(fist):
			spawn_fist()
		await get_tree().create_timer(current_spawn_interval).timeout

func spawn_fist():
	if fist_scene:
		fist = fist_scene.instantiate()
		fist.speed = current_fist_speed  # Set the speed before adding
		add_child(fist)
		fist.add_to_group("boss")

		if not fist.is_connected("boss_damaged", Callable(get_parent(), "on_boss_damaged")):
			fist.connect("boss_damaged", Callable(get_parent(), "on_boss_damaged"))
	else:
		print("Error: Fist scene is not assigned!")

func _on_boss_damaged(damage: int):
	current_health -= damage
	current_health = max(current_health, 0)
	current_hits += 1
	
	update_health_bar()
	
	# Phase transition check
	if current_hits >= hits_to_phase2 and not is_phase2:
		start_phase2()
	
	if current_health <= 0:
		print("Boss defeated")
		queue_free()

func start_phase2():
	is_phase2 = true
	current_spawn_interval = phase2_spawn_interval
	current_fist_speed = phase2_fist_speed
	print("=== PHASE 2 ACTIVATED ===")

func update_health_bar():
	if health_bar:
		var health_percentage = (float(current_health) / max_health) * 100
		health_bar.value = health_percentage
