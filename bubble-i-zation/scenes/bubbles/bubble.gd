extends Node2D

var tier = 0
@export var maxTier = 3
@export var houseSpawnDelay = 3
var enoughSpaceToUprade = false
var upgrading = false
@export var circle_radius: float = 16.0           # Radius of the spawn circle
@export var max_attempts: int = 50
@export var house_scene: PackedScene  # Reference to the house scene
var spawned_houses: Array[Node2D] = []  # List of spawned house instances

var bubbleCrowded = false;

# Timer reference to spawn houses every 10 seconds
@onready var spawn_timer: Timer = $Timer

@onready var bubbleSprites = [
	$bubbleConstrSite,
	$bubble3x3,
	$bubble5x5,
	$bubble7x7
]

func upgradeTier():
	if tier < maxTier:
		bubbleSprites[tier].visible = false
		tier = tier + 1
		circle_radius = 16.0 * tier
		bubbleSprites[tier].visible = true



func _ready():
	# Start the timer with a 10-second interval
	spawn_timer.start(houseSpawnDelay)
	# Example: Spawn 10 houses
	#for i in range(3):
		#spawn_house()
		#print("spawned house ",i)

func spawn_house():
	for x in range(max_attempts):
		# Generate a random position within the circle
		var angle = randf() * TAU
		var distance = sqrt(randf()) * circle_radius  # sqrt for uniform distribution
		var position = Vector2(cos(angle), sin(angle)) * distance

		# Check for overlap with existing houses
		if is_position_valid(position):
			# Spawn the house scene
			var house_instance = house_scene.instantiate() as Node2D
			house_instance.position = position
			add_child(house_instance)
			spawned_houses.append(house_instance)

			# Assign a random texture from the TileSet
			house_instance.assign_tile_texture(tier)
			return  # Stop trying after a successful spawn

	print("Could not find a valid position for the house.")
	bubbleCrowded = true;

func is_position_valid(position: Vector2) -> bool:
	for house in spawned_houses:
		if house.position.distance_to(position) < house.house_size:
			return false
	return true

func _on_timer_timeout() -> void:
	upgradeTier()
	spawn_house()  # Call the spawn function
	spawn_timer.start(houseSpawnDelay)  # Restart the timer to spawn every 10 seconds
