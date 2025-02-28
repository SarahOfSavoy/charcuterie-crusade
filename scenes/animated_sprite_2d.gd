extends AnimatedSprite2D

func _ready() -> void:
	var animation_names: PackedStringArray
	animation_names = sprite_frames.get_animation_names()
	for animation_name in animation_names:
		var frame_count: int
		frame_count = sprite_frames.get_frame_count(animation_name)
		for frame_index in frame_count:
			var frame_texture: Texture2D
			var frame_duration: float
			frame_texture = sprite_frames.get_frame_texture(animation_name, frame_index)
			frame_duration = sprite_frames.get_frame_duration(animation_name, frame_index)
			var resized_frame_texture: Texture2D
			resized_frame_texture = frame_texture
			if frame_texture.get_size() != Vector2(500, 500):
				var frame_texture_image: Image
				frame_texture_image = frame_texture.get_image()
				frame_texture_image.resize(500, 500, Image.INTERPOLATE_NEAREST)
				resized_frame_texture = ImageTexture.create_from_image(frame_texture_image)
			sprite_frames.set_frame(animation_name, frame_index, resized_frame_texture, frame_duration)
