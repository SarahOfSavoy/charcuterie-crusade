extends Area2D

@export var speed: float = 400.0
@export var arc_height: float = 500.0
@export var spin_speed: float = 8.0
@export var damage_amount: int = 10

var velocity: Vector2
var gravity_force: float = 300.0
var initial_position: Vector2
var horizontal_direction: float
var throw_angle: float = 65.0
var is_stuck: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hit_sound: AudioStreamPlayer = $HitSound # Add this node

func _ready():
	initial_position = position
	horizontal_direction = sign(randf_range(-1, 1)) 
	horizontal_direction = 1 if horizontal_direction == 0 else horizontal_direction
	
	var angle_rad = deg_to_rad(throw_angle)
	velocity = Vector2(
		horizontal_direction * speed * cos(angle_rad),
		-speed * sin(angle_rad)
	)
	
	spin_speed *= randf_range(0.8, 1.2)
	spin_speed *= -1 if randf() > 0.5 else 1

func _physics_process(delta):
	if is_stuck:
		return
		
	velocity.y += gravity_force * delta
	position += velocity * delta
	sprite.rotation += spin_speed * delta
	
	if position.y > 800:
		queue_free()

func _on_body_entered(body):
	if body.name == "Player" :
		body.take_damage(10)
		queue_free()

func deal_damage(player):
	# Apply damage only
	player.take_damage(damage_amount)
	
	# Play sound if available
	if hit_sound:
		hit_sound.play()

func _on_despawn_timer_timeout():
	queue_free()
