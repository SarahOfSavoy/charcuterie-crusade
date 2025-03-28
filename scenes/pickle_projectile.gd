extends RigidBody2D

var vel_x: float
var vel_y: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = Vector2(vel_x, vel_y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
