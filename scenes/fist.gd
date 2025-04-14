extends Area2D

@export var speed: float = 500.0  # Speed at which the fist moves down and up
@export var wait_time: float = 2.0  # Time to wait before retracting
@export var max_health: int = 100  # Maximum health of the fist
@export var current_health: int = 100

enum State { MOVING_DOWN, WAITING, MOVING_UP }
var current_state: State = State.MOVING_DOWN
var wait_timer: float = 0.0
var health: int = current_health

func _ready():
	# Set a random X position between 100 and 1000
	position.x = randf_range(100, 1000)
	# Spawn the fist above the screen
	position.y = -50
	# Initialize the health bar
	

func _physics_process(delta):
	match current_state:
		State.MOVING_DOWN:
			# Move the fist downward
			position.y += speed * delta
			# Stop moving when the fist reaches y = 700
			if position.y >= 720:
				$"Punch SFX".play()
				current_state = State.WAITING
				wait_timer = wait_time  # Start the wait timer

		State.WAITING:
			# Wait for a few seconds before retracting
			wait_timer -= delta
			if wait_timer <= 0:
				current_state = State.MOVING_UP

		State.MOVING_UP:
			# Move the fist back up
			position.y -= speed * delta
			# Remove the fist when it goes off-screen
			if position.y < -50:
				queue_free()

signal boss_damaged(damage)

func take_damage(damage):
	emit_signal("boss_damaged", damage)  # Notify spawner

	flash_red()  # Call the glow effect
	
	$Damage.play()

	if current_health <= 0:
		die()

func flash_red():
	var sprite = $Sprite2D  # Adjust if your sprite has a different name
	sprite.modulate = Color(0.8, 0.3, 0.3)  # Set red tint
	await get_tree().create_timer(0.2).timeout  # Wait for 0.2 seconds
	sprite.modulate = Color(1, 1, 1)  # Reset to normal

	if current_health <= 0:
		die()

func die():
	print("Boss died")
	queue_free()  # Remove the fist from the scene


func _on_body_entered(body):
	if body.name == "Player":  # Replace with your player's name or group
		body.take_damage(20)  # Signal the player's take_damage() function
