extends Node

@export var totalHealth = 100
@onready var currentHealth : float = totalHealth

func take_damage(damage):
	currentHealth -= damage
	
	$Health.size.x = currentHealth / totalHealth * 100
