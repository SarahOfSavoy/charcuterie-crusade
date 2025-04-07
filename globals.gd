# This script will be used for any global variables
extends Node

# Global variable to keep track of the player's score
var score = 0

# Global variable that tells if the user is paused
var is_paused = false

# Maximum player health
var max_health = 100

# Player health
var health = max_health

# Last checkpoint
var checkpoint = null

# Starting position
var starting_pos = Vector2(893, 648)

# Player upgrades
var can_attack = false
var max_jumps = 1
var can_dash = false
