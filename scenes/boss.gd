extends Node2D

@export var max_health: int = 100
@export var hits_to_phase2: int = 10

var current_hits: int = 0
var is_phase2: bool = false
var health: int = max_health

@onready var fist_spawner = $FistSpawner
@onready var knife_spawner = $KnifeSpawner
@onready var music_player: AudioStreamPlayer2D = $Music
@onready var victory_label: Label = get_node_or_null("/root/BossLevel/VictoryLabel")


func _ready():
		
	health = max_health
	# Hide the victory label at start
	if victory_label:
		victory_label.visible = false

	# Start Phase 1
	fist_spawner.start_spawning()

func on_boss_damaged(damage):
	health -= damage
	health = max(0, health)
	current_hits += 1
	
	$CanvasLayer/Label.text = str(health) + " / 100"
	
	if current_hits >= hits_to_phase2 and not is_phase2:
		start_phase2()
	
	if health <= 0:
		die()

func start_phase2():
	is_phase2 = true
	
	fist_spawner.current_spawn_interval *= 0.6
	fist_spawner.current_fist_speed *= 1.5
	
	if knife_spawner:
		knife_spawner.start_spawning()
	else:
		push_error("Knife Spawner not found!")

func die():

	if victory_label:
		victory_label.visible = true
	
	get_parent().killed_boss()
	
	queue_free()
