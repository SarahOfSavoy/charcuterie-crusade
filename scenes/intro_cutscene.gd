extends Control

var cutscene_images : Array = []
var current_image_index : int = 0
var sprite : Sprite2D
var timer : Timer
var cutscene_music : AudioStreamPlayer2D  # Declare the music player node

func _ready() -> void:
	sprite = $Sprite
	timer = $Timer
	
	# Set sprite to center of viewport
	sprite.position = get_viewport_rect().size / 2
	
	cutscene_music = $CutsceneMusic  # Assign your AudioStreamPlayer here
	
	# Preload cutscene images
	cutscene_images = [
		preload("res://assets/art/backgrounds/intro_cutscene1.png"),
		preload("res://assets/art/backgrounds/intro_cutscene2.png"),
		preload("res://assets/art/backgrounds/intro_cutscene3.png"),
		preload("res://assets/art/backgrounds/intro_cutscene4.png"),
		preload("res://assets/art/backgrounds/intro_cutscene5.png"),
		# Add more images as needed
	]
	
	# Start with the first image
	sprite.texture = cutscene_images[current_image_index]
	_adjust_sprite_size()

	# Start the cutscene music
	cutscene_music.play()

	# Set up the timer (2 seconds delay per image)
	timer.wait_time = 2
	timer.one_shot = true
	timer.start()

func _process(delta: float) -> void:
	if timer.time_left <= 0:
		if current_image_index < cutscene_images.size() - 1:
			current_image_index += 1
			sprite.texture = cutscene_images[current_image_index]
			_adjust_sprite_size()
			timer.start()
		else:
			cutscene_music.stop()
			get_tree().change_scene_to_file("res://scenes/tutorial.tscn")

# NEW FUNCTION - adjust sprite size to fit screen
func _adjust_sprite_size() -> void:
	var viewport_size = get_viewport_rect().size
	var texture_size = sprite.texture.get_size()

	# Reset scale first (important when switching between images!)
	sprite.scale = Vector2.ONE

	if texture_size.x > viewport_size.x or texture_size.y > viewport_size.y:
		var scale_factor = min(viewport_size.x / texture_size.x, viewport_size.y / texture_size.y)
		sprite.scale = Vector2(scale_factor, scale_factor)
