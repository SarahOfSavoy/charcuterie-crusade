extends RigidBody2D

var vel_x: float
var vel_y: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = Vector2(vel_x, vel_y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (abs(linear_velocity.x) < 10 and abs(linear_velocity.y) < 10) or linear_velocity.y > 1500:
		queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(15)
		queue_free()
