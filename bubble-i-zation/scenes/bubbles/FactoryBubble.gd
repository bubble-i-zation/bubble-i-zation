extends Node2D

class_name FactoryBubble

var tier = 0
@export var maxTier = 2
@export var houseSpawnDelay = 3
@export var producedRescource: PackedScene
var enoughSpaceToUprade = false
var upgrading = false

var rescourceType: ProductionResource.ResourceType

# Timer reference to spawn houses every 10 seconds
@onready var spawn_timer: Timer = $Timer

@onready var bubbleSprites = [
	$bubbleConstrSite,
	$bubble3x3,
	$bubble5x5,
	$bubble7x7
]

@onready var bubbleBGSprites = [
	$BG/BG3x3,
	$BG/BG5x5,
	$BG/BG7x7
]

func upgradeTier():
	if tier < maxTier:
		$AnimatedSprite2D.visible = true
		bubbleSprites[tier].visible = false
		bubbleBGSprites[tier-1].visible = false
		tier = tier + 1
		bubbleSprites[tier].visible = true
		bubbleBGSprites[tier-1].visible = true



func _ready():
	# Start the timer with a 10-second interval
	spawn_timer.start(houseSpawnDelay)
	# Example: Spawn 10 houses
	#for i in range(3):
		#spawn_house()
		#print("spawned house ",i)
	$AnimatedSprite2D.play("o2")

func _on_timer_timeout() -> void:
	if tier == 0 or upgrading:
		upgradeTier()
