extends Area2D

var is_attacking = false

# Attack should be off by default
func _ready():
	hide()
	$CollisionShape2D.disabled = true

func _physics_process(_delta: float) -> void:
	if(is_attacking):
		rotate_attack_area()
	else:
		get_node("/root/Main/Player/RotationCenter").rotation = -1

# Attack area should be activated while player is attacking
func _on_player_attack_started():
	is_attacking = true
	activate_attack_area()

# Once attack finishes, area should be deactivated
func _on_attack_duration_timeout():
	is_attacking = false
	deactivate_attack_area()

# Activate the attack area
func activate_attack_area():
	# Show the attack area
	show()
	# Enable the collision shape for the attack area
	$CollisionShape2D.disabled = false

	# Connect the body_entered signal to handle mob damage
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

# Deactivate the attack area
func deactivate_attack_area():
	# Hide the attack area
	hide()
	# Disable the collision shape for the attack area
	$CollisionShape2D.disabled = true

	# Disconnect the body_entered signal to stop handling mob damage
	if is_connected("body_entered", Callable(self, "_on_body_entered")):
		disconnect("body_entered", Callable(self, "_on_body_entered"))
		
func rotate_attack_area():
	get_node("/root/Main/Player/RotationCenter").rotation += 0.3

# Handle when a body enters the attack area
func _on_body_entered(body):
	if body.is_in_group("mobs"):  # Only damage the mob if it's in the "mobs" group
		body.take_damage()
