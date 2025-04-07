extends Node

# Total health of the entity
@export var totalHealth = 100
# Current health of the entity. Starts at totalHealth
@onready var currentHealth : float = totalHealth

var image_width = 577

# Called by the entity when it takes damage
func take_damage(damage):
	# Subtract from the current health
	currentHealth -= damage
	
	# Alter the size of the health bar relative to the current health
	$damage.set_modulate(Color(1, 1, 1, 1 - currentHealth / totalHealth))
	$Label.text = str(currentHealth) + " / " + str(totalHealth)
