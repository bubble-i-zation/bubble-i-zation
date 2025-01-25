extends Node2D

@export var house_size: float = 16.0             # Distance threshold for house overlap

@onready var house_tiles1 = [
	$Sprite2D,
	$Sprite2D2,
	$Sprite2D3,
	$Sprite2D4,
]
@onready var house_tiles2 = [
	$Sprite2D5,
	$Sprite2D6,
	$Sprite2D7,
	$Sprite2D8,
]
@onready var house_tiles3 = [
	$Sprite2D9,
	$Sprite2D10,
]

func assign_tile_texture(tier):
	deactivateTiles()
	if tier == 1:
		# Choose a random tile ID
		house_tiles1.pick_random().visible = true
		house_size = 16
	elif tier == 2:
		house_tiles2.pick_random().visible = true
		house_size = 32
	elif tier == 3:
		house_tiles3.pick_random().visible = true
		house_size = 48

func deactivateTiles():
	for tile in house_tiles1:
		tile.visible = false
	for tile in house_tiles2:
		tile.visible = false
	for tile in house_tiles3:
		tile.visible = false
