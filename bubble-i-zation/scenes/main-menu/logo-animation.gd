extends Sprite2D

@export var screw_speed = 0.002  # Speed of the screw animation
@export var screw_amount = 10  # Amount the screw moves up and down

var original_position

func _ready():
	original_position = position  # Store the initial position

func _process(delta):
	# Calculate the new Y position using a sine wave
	var new_y = original_position.y + sin(Time.get_ticks_msec() * screw_speed) * screw_amount

	# Update the sprite's position
	position.y = new_y
