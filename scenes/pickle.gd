extends CharacterBody2D

@export var speed: float = 50.0
@export var patrol_distance: float = 100.0
@export var max_health: int = 15  # Mob dies after 3 hits
@export var should_patrol: bool = true  # Controls whether mob should patrol
@export var patrol_pause_duration: float = 1.0  # Time to pause at patrol boundaries
@export var projectile_scene: PackedScene

var direction: int = 1  # 1 for right, -1 for left
var start_position: Vector2
var health: int = max_health
var player_in_range: bool = false
var is_attacking: bool = false
var is_paused: bool = false  # Tracks whether the mob is paused at a boundary
var attack_range: float = 0.0  # Will be set dynamically based on DetectionArea
var player: Node2D = null  # Reference to the player
var original_direction: int = 1  # Store the original patrol direction

func _ready():
	start_position = position
	original_direction = direction  # Store the initial patrol direction
	# Set attack_range to the bounds of the DetectionArea
	var detection_shape = $Detection/CollisionShape2D.shape
	if detection_shape is RectangleShape2D:
		attack_range = detection_shape.size.x  # Use half the width as the range

func _physics_process(_delta):
	if health <= 0:
		die()  # Handle mob death
		return

	if player_in_range:
		face_player()
		if not is_attacking:
			stop_and_attack()
	elif should_patrol and not is_paused:  # Only patrol if should_patrol is true and not paused
		patrol()

func patrol():
	velocity.x = direction * speed
	move_and_slide()

	# Check if the mob has reached the end of its patrol area
	if abs(position.x - start_position.x) >= patrol_distance:
		pause_at_boundary()

	# Flip the sprite based on movement direction
	flip_sprite()

func pause_at_boundary():
	is_paused = true  # Pause the mob
	velocity = Vector2.ZERO  # Stop moving

	# Wait for the patrol_pause_duration before turning around
	await get_tree().create_timer(patrol_pause_duration).timeout

	# Turn around and reset the start position
	direction *= -1
	start_position = position
	is_paused = false  # Resume patrolling

func face_player():
	if player:
		# Determine the direction to face the player
		var new_direction = 1 if player.position.x > position.x else -1
		if new_direction != direction:
			# Immediately turn around to face the player
			direction = new_direction
			flip_sprite()

func flip_sprite():
	# Flip the sprite based on the direction
	$Sprite2D.flip_h = direction == -1

func stop_and_attack():
	is_attacking = true
	velocity = Vector2.ZERO  # Stop moving
	await start_attack()  # Wait for the attack to complete
	is_attacking = false

func start_attack():
	# Wait for a short delay before attacking
	await get_tree().create_timer(3.0).timeout  # Adjust delay as needed
	attack()

func attack():
	var projectile = projectile_scene.instantiate()
	
	var g = get_gravity().y
	var x_y = player.global_position - global_position
	var x = x_y.x
	var y = x_y.y
	var initial_angle = 7 * PI / 4
	if direction == -1:
		initial_angle = 5 * PI / 4
	
	
	var initial_velocity = sqrt((g * x**2) / (2 * (cos(initial_angle)**2) * (-x * tan(initial_angle) + y)))
	
	
	projectile.vel_x = initial_velocity * cos(initial_angle)
	projectile.vel_y = initial_velocity * sin(initial_angle)
	add_child(projectile)

func take_damage(damage):
	health -= damage
	$HealthBar.take_damage(5)

func die():
	# Add 200 points to the score
	Globals.score += 200
	queue_free()  # Remove the mob from the scene

func _on_detection_area_body_entered(body):
	if body.name == "Player":  # Replace with your player's name or group
		player_in_range = true
		player = body  # Store a reference to the player
		# Immediately face the player when they enter detection range
		face_player()

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		player = null  # Clear the reference to the player
		# Return to the original patrol direction
		direction = original_direction
		should_patrol = true  # Resume patrolling
		flip_sprite()
