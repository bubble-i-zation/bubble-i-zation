extends Node2D

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

@onready var allHouses = [
	house_tiles1,
	house_tiles2,
	house_tiles3
]

func assign_tile_texture(tier):
	deactivateTiles()
	var houseTier
	if tier == 0:
		# Choose a random tile ID
		house_tiles1.pick_random().visible = true
	elif tier == 1:
		house_tiles2.pick_random().visible = true
	elif tier == 2:
		house_tiles3.pick_random().visible = true
	

func deactivateTiles():
	for tile in house_tiles1:
		tile.visible = false
	for tile in house_tiles2:
		tile.visible = false
	for tile in house_tiles3:
		tile.visible = false
