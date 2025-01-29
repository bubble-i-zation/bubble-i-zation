extends Node2D

class_name FactoryBubble

var tier = 0
@export var buildingcosts: int = 10
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

var testTransportQuest: Quest

func upgradeTier():
	if tier < maxTier:
		$AnimatedSprite2D.visible = true
		bubbleSprites[tier].visible = false
		bubbleBGSprites[tier-1].visible = false
		tier = tier + 1
		bubbleSprites[tier].visible = true
		bubbleBGSprites[tier-1].visible = true

func setRessourceType(rescourceType: ProductionResource.ResourceType):
	rescourceType = rescourceType
	print("rescourceType: ", rescourceType)
	$AnimatedSprite2D.play(ProductionResource.ResourceType.keys()[rescourceType])

func _ready():
	# Start the timer with a 10-second interval
	spawn_timer.start(houseSpawnDelay)
	
	testTransportQuest = Quest.new()
	for i in range(0, buildingcosts):
		var testTransportJob = TransportJob.new()
		testTransportJob.destination = self.position
		testTransportJob.resourceType = ProductionResource.ResourceType.BaumMatsWood
		testTransportQuest.add_objective(testTransportJob)
	testTransportQuest.add_complete_callback(Callable(buildQuestComplete))
	QuestManager.add_quest(testTransportQuest)
func buildQuestComplete():
	if tier == 0:
		upgradeTier()
		
func _on_timer_timeout() -> void:
	if upgrading:
		upgradeTier()
