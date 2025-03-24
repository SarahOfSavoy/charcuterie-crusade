extends Area2D

@export var speed: float = 450.0  # Speed at which the fist moves down and up
@export var wait_time: float = 2.0  # Time to wait before retracting
@export var max_health: int = 100  # Maximum health of the fist
@export var health_bar: ProgressBar  # Reference to the health bar UI

enum State { MOVING_DOWN, WAITING, MOVING_UP }
var current_state: State = State.MOVING_DOWN
var wait_timer: float = 0.0
var health: int = max_health

func _ready():
	# Set a random X position between 100 and 1000
	position.x = randf_range(100, 1000)
	# Spawn the fist above the screen
	position.y = -50
	# Initialize the health bar
	update_health_bar()

func _physics_process(delta):
	match current_state:
		State.MOVING_DOWN:
			# Move the fist downward
			position.y += speed * delta
			# Stop moving when the fist reaches y = 700
			if position.y >= 720:
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

func take_damage(damage):
	print("Boss took damage! Health:", health)
	health -= damage
	update_health_bar()
	if health <= 0:
		die()

func die():
	print("Boss died")
	queue_free()  # Remove the fist from the scene

func update_health_bar():
	if health_bar:
		health_bar.value = (float(health) / max_health) * 100  # Update health bar percentage

func _on_body_entered(body):
	if body.name == "Player":  # Replace with your player's name or group
		body.take_damage(20)  # Signal the player's take_damage() function
