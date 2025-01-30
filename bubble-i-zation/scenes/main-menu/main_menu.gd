extends Control

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D  # Adjust path as needed

func _ready():
	update_sprite_size()
	get_viewport().connect("size_changed", Callable(self, "update_sprite_size"))  # Adjust on resize

func update_sprite_size():
	if not sprite or not sprite.sprite_frames:
		return

	var animation_name = sprite.animation
	if not sprite.sprite_frames.has_animation(animation_name):
		return

	var frame_texture = sprite.sprite_frames.get_frame_texture(animation_name, 0)
	if not frame_texture:
		return

	var texture_size = frame_texture.get_size()
	var screen_size = get_viewport_rect().size

	# Scale to fit the screen while maintaining aspect ratio
	var scale_factor = max(screen_size.x / texture_size.x, screen_size.y / texture_size.y)
	sprite.scale = Vector2(scale_factor, scale_factor)

	# Center the sprite in the viewport
	sprite.position = screen_size / 2
