extends Path2D

@export var speed : float = 1

func _ready() -> void:
	$AnimationPlayer.play("move")
	$AnimationPlayer.speed_scale = speed
	set_process(false)
