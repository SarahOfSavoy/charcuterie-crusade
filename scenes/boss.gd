extends Node2D

@export var max_health: int = 100
@export var phase2_health_threshold: int = 50  # Health threshold for Phase 2

var health: int = max_health
var is_phase2: bool = false

@onready var fist_spawner = $FistSpawner
@onready var knife_spawner = $KnifeSpawner

func _ready():
	# Start Phase 1
	fist_spawner.start_spawning()

func take_damage(damage):
	health -= damage
	if health <= phase2_health_threshold and not is_phase2:
		start_phase2()

	if health <= 0:
		die()

func start_phase2():
	is_phase2 = true
	# Increase the fist spawn rate
	fist_spawner.spawn_interval = 1.0
	# Start spawning knives
	knife_spawner.start_spawning()

func die():
	print("Butcher King defeated!")
	queue_free()
