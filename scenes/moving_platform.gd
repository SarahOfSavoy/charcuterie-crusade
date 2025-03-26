extends Path2D

@export var speed : float = 1

func _ready() -> void:
	$AnimationPlayer.play("move")
	$AnimationPlayer.speed_scale = speed

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_down"):
		$Platform.collision_layer = 2
		await get_tree().create_timer(0.1).timeout
		$Platform.collision_layer = 1
