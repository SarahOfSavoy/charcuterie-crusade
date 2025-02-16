extends CharacterBody2D

const SPEED = 400.0
const DASHSPEED = 1500.0
const JUMP_VELOCITY = -600.0

# Counter to allow double jumps but not more than that
var current_jumps = 0

var is_dashing = false

var is_attacking = false

# Store the x direction the player was last looking
var last_direction = 1

signal attack_started

func _physics_process(delta: float) -> void:
	# Update values not directly related to player input
	if is_on_floor():
		current_jumps = 0
	else:
		# Apply gravity
		velocity += get_gravity() * delta
	
	# Handle any movement directly controlled by player
	actions()
	
	# Handle collisions with other objects
	move_and_slide()
	
func actions():
	# Handle any movement directly controlled by player
	if is_dashing == false:
		walk()
	
		jump()
		
	attack()
	
	dash()
	

func walk():
	# Handle walking and player direction
	var direction := Input.get_axis("walk_left", "walk_right")
	# Update last_direction when player actually moves
	if direction == -1 or direction == 1:
			last_direction = direction
			flip(direction)
		
	# Move player left or right
	velocity.x = direction * SPEED
		
func jump():
	# Launches the player vertically, can jump one additional time while while midair
	if Input.is_action_just_pressed("jump") and current_jumps < 2:
		velocity.y = JUMP_VELOCITY
		current_jumps += 1
		
func dash():
	# Handle turning dash input into movement
	if Input.is_action_just_pressed("dash") and is_dashing == false:
		is_dashing = true
		$"DashDuration".start()
		
	if is_dashing == true:
		velocity.x = last_direction * DASHSPEED
		velocity.y = 0
	
func attack():
	# Handle turning attack input into movement
	if Input.is_action_just_pressed("attack") and is_attacking == false:
		is_attacking = true
		$"AttackDuration".start()
		attack_started.emit()
		
func flip(direction):
	# Flips character body 2D left or right
		scale.y = direction
		rotation = PI/2 - direction * PI/2
		
func _on_dash_duration_timeout():
	is_dashing = false
	velocity.x = 0

func _on_attack_duration_timeout():
	is_attacking = false
