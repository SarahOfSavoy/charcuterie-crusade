extends Node2D

@export var max_health: int = 100
@export var hits_to_phase2: int = 10
var current_hits: int = 0
var is_phase2: bool = false

var health: int = max_health

@onready var fist_spawner = $FistSpawner
@onready var knife_spawner = $KnifeSpawner

func _ready():
	health = max_health
	fist_spawner.start_spawning()

func on_boss_damaged(damage):
	health -= damage
	health = max(0, health)
	current_hits += 1
	
	print("Boss hit! Total hits: ", current_hits, " | Health: ", health)
	
	if current_hits >= hits_to_phase2 and not is_phase2:
		start_phase2()
	
	if health <= 0:
		die()

func start_phase2():
	is_phase2 = true
	print("=== PHASE 2 ACTIVATED ===")
	
	# Phase 2 adjustments
	fist_spawner.current_spawn_interval *= 0.6  # 40% faster spawning
	fist_spawner.current_fist_speed *= 1.5      # 50% faster movement
	
	if knife_spawner:
		knife_spawner.start_spawning()
	else:
		push_error("Knife Spawner not found!")

func die():
	print("Butcher King defeated!")
	queue_free()
