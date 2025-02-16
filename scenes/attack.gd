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

# TODO: get attack to damage enemies
func activate_attack_area():
	pass

# TODO: get attack to stop damaging enemies
func deactivate_attack_area():
	pass
