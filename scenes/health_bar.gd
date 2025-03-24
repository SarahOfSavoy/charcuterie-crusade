extends Node

# Total health of the entity
@export var totalHealth = 100
# Current health of the entity. Starts at totalHealth
@onready var currentHealth : float = totalHealth

# Called by the entity when it takes damage
func take_damage(damage):
	# Subtract from the current health
	currentHealth -= damage
	
	# Alter the size of the health bar relative to the current health
	$Health.size.x = currentHealth / totalHealth * 100
