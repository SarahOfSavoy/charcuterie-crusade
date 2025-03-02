extends CharacterBody2D

@export var speed: float = 50.0
@export var patrol_distance: float = 100.0
@export var max_health: int = 3  # Mob dies after 3 hits
@export var should_patrol: bool = true  # Controls whether mob should patrol


var direction: int = 1  # 1 for right, -1 for left
var start_position: Vector2
var health: int = max_health
var player_in_range: bool = false
var is_attacking: bool = false
var attack_range: float = 0.0  # Will be set dynamically based on DetectionArea

func _ready():
	start_position = position
	# Set attack_range to the bounds of the DetectionArea
	var detection_shape = $DetectionArea/CollisionShape2D.shape
	if detection_shape is CircleShape2D:
		attack_range = detection_shape.radius
	elif detection_shape is RectangleShape2D:
		attack_range = detection_shape.size.x / 2  # Use half the width as the range

func _physics_process(_delta):
	if health <= 0:
		die()  # Handle mob death
		return

	if player_in_range and not is_attacking:
		stop_and_attack()
	elif should_patrol:  # Only patrol if should_patrol is true
		patrol()

func patrol():
	velocity.x = direction * speed
	move_and_slide()

	# Check if the mob has reached the end of its patrol area
	if abs(position.x - start_position.x) >= patrol_distance:
		direction *= -1  # Reverse direction
		start_position = position  # Reset the start position for the new patrol direction

func stop_and_attack():
	is_attacking = true
	velocity = Vector2.ZERO  # Stop moving
	await start_attack()  # Wait for the attack to complete
	is_attacking = false

func start_attack():
	# Wait for a short delay before attacking
	await get_tree().create_timer(1.0).timeout  # Adjust delay as needed
	attack()

func attack():
	var player = get_node("/root/Main/Player")  # Updated path to reflect "Main" node
	if player and position.distance_to(player.position) <= attack_range:
		print("Mob attacks!")
		# Implement attack logic here (e.g., damage the player)

func take_damage():
	health -= 1
	$HealthBar.take_damage(1)

func die():
	# Add 200 points to the score
	Globals.score += 200
	
	queue_free()  # Remove the mob from the scene

func _on_detection_area_body_entered(body):
	if body.name == "Player":  # Replace with your player's name or group
		player_in_range = true

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		player_in_range = false
