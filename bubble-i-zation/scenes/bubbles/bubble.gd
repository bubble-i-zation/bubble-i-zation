extends Node2D

class_name Bubble

@export var tier = 0
@export var maxTier = 4
@export var houseSpawnDelay = 40
@export var porterSpawnDelay = 20
@export var consumptionDelay = 30
@export var maxPopulation = 3

@export	var o2ConsumptionPerPopulation = 2
@export	var waterConsumptionPerPopulation = 1
@export	var foodConsumptionPerPopulation = 1

@export var o2Threshold = 300
@export var waterThreshold = 150
@export var foodThreshold = 150
@export var buildMatsThreshold = 50

@export var o2ThresholdMin = 100
@export var waterThresholdMin = 50
@export var foodThresholdMin = 50
@export var buildMatsThresholdMin = 30

var enoughSpaceToUprade = false
var upgrading = false
@export var circle_radius = [
	0,
	12.0,
	24.0,
	37,
	60
]          # Radius of the spawn circle
@export var buildingHeightOffset: float = 6.0
@export var max_attempts: int = 350
@export var house_scene: PackedScene  # Reference to the house scene
@export var porter_scene: PackedScene # Reference to the porter scene
var spawned_houses: Array[Node2D] = []  # List of spawned house instances
var bubbleCrowded = false;

@onready var ui = $UI_onNode
# Timer reference to spawn houses every 10 seconds
@onready var spawn_timer: Timer = $Timer
@onready var porter_spawn_timer: Timer = $Timer2
@onready var consumption_timer: Timer = $Timer3
@onready var housesNode = $houses

@export var house_size = [
	9.0,
	11.0,
	15.0,
	15.0
]         # Distance threshold for house overlap

@onready var bubbleSprites = [
	$bubbleConstrSite,
	$bubble3x3,
	$bubble5x5,
	$bubble7x7,
	$bubble10x10
]

@onready var bubbleBGSprites = [
	$BG/BG3x3,
	$BG/BG5x5,
	$BG/BG7x7,
	$BG/BG7x7
]

@export var inventoryNew = {
	BauMatsStone = 0,
	BaumMatsWood = 200,
	Brennstoff = 0,
	Food = 250,
	Oxygen = 500,
	Water = 300,
	Population = 3,
}

var nav3x3
var nav7x7
var nav5x5

func _ready():
	if GlobalRessources != null:
		GlobalRessources.add_to_cities(self)
	print("wood: ",inventoryNew["BaumMatsWood"])
	bubbleSprites[tier].visible = true
	
	housesNode.y_sort_enabled = true
	# Start the timer with a 10-second interval
	spawn_timer.start(houseSpawnDelay)
	porter_spawn_timer.start(porterSpawnDelay)
	consumption_timer.start(consumptionDelay)
	ui.nodeInUse = true
	

	if tier == 0:
		var testTransportQuest = Quest.new()
		var testTransportJob = TransportJob.new()
		testTransportJob.destination = self.position
		testTransportJob.resourceType = ProductionResource.ResourceType.BaumMatsWood
		testTransportQuest.add_objective(testTransportJob)
		testTransportQuest.add_complete_callback(Callable(buildQuestComplete))
		QuestManager.add_quest(testTransportQuest)

var time_passed = 0.0  # Tracks time

func _process(delta: float) -> void:
	#todo: only check all couple of seconds if new job is needed
	time_passed += delta
	if time_passed >= 3.0:  # Execute every 3 seconds
		time_passed = 0.0  # Reset timer
		if inventoryNew["Oxygen"] < o2Threshold:
			var urgency = 0
			if inventoryNew["Oxygen"] < o2ThresholdMin:
				urgency = 2
			var testTransportQuest = Quest.new()
			var testTransportJob = TransportJob.new(urgency)
			testTransportJob.destination = self.position
			testTransportJob.destinationCity = self
			testTransportJob.resourceType = ProductionResource.ResourceType.Oxygen
			testTransportQuest.add_objective(testTransportJob)
			testTransportQuest.add_complete_callback(Callable(buildQuestComplete))
			QuestManager.add_quest(testTransportQuest)
		if inventoryNew["Water"] < waterThreshold:
			var urgency = 0
			if inventoryNew["Water"] < waterThresholdMin:
				urgency = 2
			var testTransportQuest = Quest.new()
			var testTransportJob = TransportJob.new(urgency)
			testTransportJob.destination = self.position
			testTransportJob.destinationCity = self
			testTransportJob.resourceType = ProductionResource.ResourceType.Water
			testTransportQuest.add_objective(testTransportJob)
			testTransportQuest.add_complete_callback(Callable(buildQuestComplete))
			QuestManager.add_quest(testTransportQuest)
		if inventoryNew["Food"] < foodThreshold:
			var urgency = 0
			if inventoryNew["Food"] < foodThresholdMin:
				urgency = 2
			var testTransportQuest = Quest.new()
			var testTransportJob = TransportJob.new(urgency)
			testTransportJob.destination = self.position
			testTransportJob.destinationCity = self
			testTransportJob.resourceType = ProductionResource.ResourceType.Food
			testTransportQuest.add_objective(testTransportJob)
			testTransportQuest.add_complete_callback(Callable(buildQuestComplete))
			QuestManager.add_quest(testTransportQuest)
		if inventoryNew["BaumMatsWood"] < buildMatsThreshold:
			var urgency = 0
			if inventoryNew["BaumMatsWood"] < buildMatsThresholdMin:
				urgency = 2
			var testTransportQuest = Quest.new()
			var testTransportJob = TransportJob.new(urgency)
			testTransportJob.destination = self.position
			testTransportJob.destinationCity = self
			testTransportJob.resourceType = ProductionResource.ResourceType.BaumMatsWood
			testTransportQuest.add_objective(testTransportJob)
			testTransportQuest.add_complete_callback(Callable(buildQuestComplete))
			QuestManager.add_quest(testTransportQuest)
		
func upgradeTier():
	bubbleCrowded = false
	if tier < maxTier:
		bubbleSprites[tier].visible = false
		bubbleBGSprites[tier-1].visible = false
		tier = tier + 1
		bubbleSprites[tier].visible = true
		bubbleBGSprites[tier-1].visible = true
		
func buildQuestComplete():
	if tier == 0:
		upgradeTier()
func spawn_house():
	for x in range(max_attempts):
		# Generate a random position within the circle
		var angle = randf() * TAU
		var distance = sqrt(randf()) * circle_radius[tier]  # sqrt for uniform distribution
		var position = Vector2(cos(angle), sin(angle)) * distance
		var houseTier = randi_range(0,tier-1)
		#add an offset, because the buildings have height
		position.y = position.y + house_size[houseTier]

		# Check for overlap with existing houses
		if is_position_valid(position, house_size[houseTier]):
			# Spawn the house scene
			var house_instance = house_scene.instantiate() as Node2D
			house_instance.position = position
			
			#add_child(house_instance)
			housesNode.add_child(house_instance)
			spawned_houses.append(house_instance)
			
			#increase max population for each house that is added (tier is important)
			maxPopulation += houseTier
			#consume BuildingMats
			remove_resource(ProductionResource.ResourceType.BaumMatsWood, houseTier)
			
			# Assign a random texture from the TileSet
			house_instance.assign_tile_texture(houseTier)
			return  # Stop trying after a successful spawn

	print("Could not find a valid position for the house.")
	bubbleCrowded = true;
	
func spawn_porter():
	# Spawn the house scene
		var porter_instance = porter_scene.instantiate() as Node2D
		var porterSpawnPos = position
		porterSpawnPos.x = porterSpawnPos.x + randi_range(-1,1)
		porterSpawnPos.y = porterSpawnPos.x + randi_range(1,3)
		porter_instance.position = porterSpawnPos
		
		self.add_child(porter_instance)
		
		inventoryNew["Population"] += 1
		
func is_position_valid(position: Vector2, house_size) -> bool:
	for house in spawned_houses:
		if house.position.distance_to(position) < house_size:
			return false
	return true

func remove_resource(resource:ProductionResource.ResourceType, quantity = 1):
	inventoryNew[GlobalRessources.resource_key_map[resource]] -= quantity

func add_resource(resource:ProductionResource.ResourceType, quantity = 1):
	inventoryNew[GlobalRessources.resource_key_map[resource]] += quantity

func _on_timer_timeout() -> void:
	
	if bubbleCrowded:
			upgradeTier()
	if tier != 0:
		spawn_house()  # Call the spawn function
		spawn_timer.start(houseSpawnDelay)  # Restart the timer to spawn every 10 seconds
		
func _on_timer_2_timeout() -> void:
	if inventoryNew["Population"] < maxPopulation:
		spawn_porter()
		porter_spawn_timer.start(porterSpawnDelay)  # Restart the timer to spawn every 10 seconds

func _on_timer_3_timeout() -> void:
	#consume food periodically
	var foodConsumption = inventoryNew["Population"] * foodConsumptionPerPopulation
	var o2Consumption = inventoryNew["Population"] * o2ConsumptionPerPopulation
	var waterConsumption = inventoryNew["Population"] * waterConsumptionPerPopulation
	remove_resource(ProductionResource.ResourceType.Food, foodConsumption)
	remove_resource(ProductionResource.ResourceType.Oxygen, o2Consumption)
	remove_resource(ProductionResource.ResourceType.Water, waterConsumption)
	consumption_timer.start(consumptionDelay)
	
