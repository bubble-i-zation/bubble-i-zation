extends Node2D

class_name Bubble

@export var tier = 0
@export var maxTier = 3
@export var houseSpawnDelay = 3
@export var porterSpawnDelay = 5
@export var maxPopulation = 3
var enoughSpaceToUprade = false
var upgrading = false
@export var circle_radius = [
	0,
	12.0,
	24.0,
	37,
]          # Radius of the spawn circle
@export var buildingHeightOffset: float = 6.0
@export var max_attempts: int = 350
@export var house_scene: PackedScene  # Reference to the house scene
@export var porter_scene: PackedScene # Reference to the porter scene
var spawned_houses: Array[Node2D] = []  # List of spawned house instances
var bubbleCrowded = false;

# Timer reference to spawn houses every 10 seconds
@onready var spawn_timer: Timer = $Timer
@onready var porter_spawn_timer: Timer = $Timer2
@onready var housesNode = $houses

@export var house_size = [
	9.0,
	11.0,
	15.0
]         # Distance threshold for house overlap

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

@export var inventoryNew = {
	BauMatsStone = 0,
	BaumMatsWood = 20,
	Brennstoff = 0,
	Food = 10,
	Oxygen = 10,
	Water = 10,
	Population = 3,
}

func upgradeTier():
	bubbleCrowded = false
	if tier < maxTier:
		bubbleSprites[tier].visible = false
		bubbleBGSprites[tier-1].visible = false
		tier = tier + 1
		bubbleSprites[tier].visible = true
		bubbleBGSprites[tier-1].visible = true
		
func _ready():
	GlobalRessources.add_to_cities(self)
	print("wood: ",inventoryNew["BaumMatsWood"])
	bubbleSprites[tier].visible = true
	
	housesNode.y_sort_enabled = true
	# Start the timer with a 10-second interval
	spawn_timer.start(houseSpawnDelay)
	porter_spawn_timer.start(porterSpawnDelay)
	

	if tier == 0:
		testTransportQuest = Quest.new()
		var testTransportJob = TransportJob.new()
		testTransportJob.destination = self.position
		testTransportJob.resourceType = ProductionResource.ResourceType.BaumMatsWood
		testTransportQuest.add_objective(testTransportJob)
		testTransportQuest.add_complete_callback(Callable(buildQuestComplete))
		QuestManager.add_quest(testTransportQuest)

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
			
			# Assign a random texture from the TileSet
			house_instance.assign_tile_texture(houseTier)
			return  # Stop trying after a successful spawn

	print("Could not find a valid position for the house.")
	bubbleCrowded = true;
	
func spawn_porter():
	# Spawn the house scene
		var porter_instance = porter_scene.instantiate() as Node2D
		var porterSpawnPos = position
		porterSpawnPos.x = porterSpawnPos.x + randi_range(-16,16)
		porterSpawnPos.y = porterSpawnPos.x + randi_range(16,24)
		porter_instance.position = porterSpawnPos
		
		self.add_child(porter_instance)
		
		inventoryNew["Population"] += 1
		
func is_position_valid(position: Vector2, house_size) -> bool:
	for house in spawned_houses:
		if house.position.distance_to(position) < house_size:
			return false
	return true

func _on_timer_timeout() -> void:
	if bubbleCrowded:
			upgradeTier()
	if tier != 0:
		spawn_house()  # Call the spawn function
		spawn_timer.start(houseSpawnDelay)  # Restart the timer to spawn every 10 seconds
		
func _on_timer_2_timeout() -> void:
	if inventoryNew["Population"] < maxPopulation:
		spawn_porter()
		spawn_timer.start(porterSpawnDelay)  # Restart the timer to spawn every 10 seconds
