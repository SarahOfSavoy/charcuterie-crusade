extends CharacterBody2D
class_name Player # Can check if a node is a Player

const SPEED = 400.0
const DASHSPEED = 1500.0
const JUMP_VELOCITY = -600.0

var health = 100
@export var max_jumps = 1
@export var can_attack = false
@export var can_dash = false

var current_jumps = 0
var current_dashes = 0

var is_dashing = false
var is_attacking = false
var is_airborne = false
var is_walking = false

var dash_cooldown = false
var attack_cooldown = false

# Store the x direction the player was last looking
var last_direction = 1

signal attack_started

func _physics_process(delta: float) -> void:
	# Ignore any input if the player is paused
	if Globals.is_paused:
		return
	
	# Check if the player is dead
	if health <= 0:
		Globals.is_paused = true
		var level_end = load("res://scenes/level_end.tscn").instantiate()
		$Camera2D.add_child(level_end)
	
	# Update values not directly related to player input
	if is_on_floor():
		is_airborne = false
		current_jumps = 0
		if dash_cooldown == false:
			current_dashes = 0
		 
	else:
		# Apply gravity
		velocity += get_gravity() * delta
		is_airborne = true
		
	# Handle any movement directly controlled by player
	actions()
	# Handle player animations
	animations()
	# Handle collisions with other objects
	move_and_slide()
	
func actions():
	# Handle any movement directly controlled by player
	if is_dashing == false:
		walk()
		jump()
	
	if can_attack:
		attack()
	if can_dash:
		dash()
	
func walk():
	# Handle walking and player direction
	var direction := Input.get_axis("walk_left", "walk_right")
	# Update last_direction when player actually moves
	if direction == -1 or direction == 1:
		is_walking = true
		last_direction = direction
		flip(direction)
		if($SFX/Walking.playing == false and is_airborne == false):
			$SFX/Walking.play()
	else:
		is_walking = false
		$SFX/Walking.stop()
	# Move player left or right
	velocity.x = direction * SPEED
		
func jump():
	# Launches the player vertically, can jump one additional time while while midair
	if Input.is_action_just_pressed("jump") and current_jumps < max_jumps:
		$SFX/Jumping.play()
		velocity.y = JUMP_VELOCITY
		current_jumps += 1
		
func dash():
	# Handle turning dash input into movement
	if Input.is_action_just_pressed("dash") and is_dashing == false and current_dashes == 0:
		$SFX/Dashing.play()
		is_dashing = true
		dash_cooldown = true
		current_dashes += 1
		$"DashDuration".start()
		$"DashCooldown".start()
		
	if is_dashing == true:
		velocity.x = last_direction * DASHSPEED
		velocity.y = 0
	
func attack():
	# Handle turning attack input into movement
	if Input.is_action_just_pressed("attack") and is_attacking == false and attack_cooldown == false:
		$SFX/Attacking.play()
		is_attacking = true
		attack_cooldown = true
		$"AttackDuration".start()
		$"AttackCooldown".start()
		attack_started.emit()
		
func flip(direction):
	# Flips character body 2D left or right
		scale.y = direction
		rotation = PI/2 - direction * PI/2
		
		
func animations():
	# Handle player animations
	if is_dashing:
		$"AnimatedSprite2D".play("dash")
	elif is_attacking:
		$"AnimatedSprite2D".play("attack")
	elif is_airborne:
		$"AnimatedSprite2D".play("jump")
	elif is_walking:
		$"AnimatedSprite2D".play("walk")
	else:
		$"AnimatedSprite2D".play("idle")
	
func _on_dash_duration_timeout():
	is_dashing = false
	velocity.x = 0

func _on_attack_duration_timeout():
	is_attacking = false

func _on_dash_cooldown_timeout():
	dash_cooldown = false

func _on_attack_cooldown_timeout():
	attack_cooldown = false

func _on_knife_collected() -> void:
	can_attack = true

func _on_pepper_collected() -> void:
	max_jumps += 1
	
# Function called elsewhere to deal damage to the player
func take_damage(damage):
	# Update the player health
	health -= damage
	# Update the health bar
	get_parent().get_node("HUD/Health/HealthBar").take_damage(damage)
