extends Area2D

# Attack should be off by default
func _ready():
	hide()
	
# Attack area should be activated while player is attacking
func _on_player_attack_started():
	show()
	activate_attack_area()

# Once attack finishes, area should be deactivated
func _on_attack_duration_timeout():
	hide()
	deactivate_attack_area()

# Activate the attack area
func activate_attack_area():
	# Enable the collision shape for the attack area
	$CollisionShape2D.disabled = false

	# Connect the body_entered signal to handle mob damage
	connect("body_entered", Callable(self, "_on_body_entered"))

# Deactivate the attack area
func deactivate_attack_area():
	# Disable the collision shape for the attack area
	$CollisionShape2D.disabled = true

	# Disconnect the body_entered signal to stop handling mob damage
	if is_connected("body_entered", Callable(self, "_on_body_entered")):
		disconnect("body_entered", Callable(self, "_on_body_entered"))

# Handle when a body enters the attack area
func _on_body_entered(body):
	if body.is_in_group("mobs"):  # Only damage the mob if it's in the "mobs" group
		body.take_damage()
