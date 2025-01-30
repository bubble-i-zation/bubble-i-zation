extends Node

#total
var pops := 0
var matStone := 0
var matWood := 0
var food := 0
var water := 0
var oxygen := 0
var fuel := 0

var isGameScreenRunning = false;
var isGameOver = false
var gameOverScene = "res://scenes/game-over/game-over.tscn"

var cities: Array[Bubble]
var factories: Array[ressource_node]

func _ready() -> void:
	cities = []
	factories = []

func _process(delta: float) -> void:
	repeatCheck()


func repeatCheck():
	if isGameScreenRunning:
		#factory
		var fPops := 0
		var fMatStone := 0
		var fMatWood := 0
		var fFood := 0
		var fWater := 0 
		var fOxygen := 0
		var fFuel := 0
		#city
		var cPops := 0
		var cMatStone := 0
		var cMatWood := 0
		var cFood := 0
		var cWater := 0
		var cOxygen := 0
		var cFuel := 0

		for city in cities:
			if city:
				cFood += city.inventoryNew["Food"]
				cMatStone += city.inventoryNew["BauMatsStone"]
				cMatWood += city.inventoryNew["BaumMatsWood"]
				cWater += city.inventoryNew["Water"]
				cOxygen += city.inventoryNew["Oxygen"]
				cFuel += city.inventoryNew["Brennstoff"]
				cPops += city.inventoryNew["Population"]
			
		for factory in factories:
			if factory:
				fFood += factory.inventoryNew["Food"]
				fMatStone += factory.inventoryNew["BauMatsStone"]
				fMatWood += factory.inventoryNew["BaumMatsWood"]
				fWater += factory.inventoryNew["Water"]
				fOxygen += factory.inventoryNew["Oxygen"]
				fFuel += factory.inventoryNew["Brennstoff"]
				fPops += factory.inventoryNew["Population"]
			
		food = cFood
		matStone = cMatStone
		matWood = cMatWood
		water = cWater
		oxygen = cOxygen
		fuel = cFuel
		pops = cPops
		
		if (
			0 > food ||
			0 > matStone || 
			0 > matWood || 
			0 > water || 
			0 > oxygen || 
			0 > fuel || 
			0 > pops
		):
			isGameOver = true
			
		if isGameOver:
			isGameScreenRunning = false
			get_tree().change_scene_to_file(gameOverScene)
	#print("food: ",food)
	#print("matStone: ",matStone)
	#print("matWood: ",matWood)
	#print("water: ",water)
	#print("oxygen: ",oxygen)
	#print("fuel: ",fuel)
	#print("pops: ",pops)

# Helper dictionary to map ResourceType to string keys
var resource_key_map = {
	ProductionResource.ResourceType.BauMatsStone: "BauMatsStone",
	ProductionResource.ResourceType.BaumMatsWood: "BaumMatsWood",
	ProductionResource.ResourceType.Brennstoff: "Brennstoff",
	ProductionResource.ResourceType.Food: "Food",
	ProductionResource.ResourceType.Oxygen: "Oxygen",
	ProductionResource.ResourceType.Water: "Water",
	ProductionResource.ResourceType.Population: "Population"
}

func add_to_cities (ressourceNode:Bubble):
	cities.append(ressourceNode)
	
func add_to_factories (ressourceNode:ressource_node):
	factories.append(ressourceNode)

func get_factories(resource: ProductionResource.ResourceType) -> Array[ressource_node]:
	var factories_with_resource = factories.filter(func (factory: ressource_node): 
		return factory.inventoryNew[resource_key_map[resource]]>0)
	return factories_with_resource

func get_cities(resource: ProductionResource.ResourceType) -> Array[Bubble]:
	var cities_with_resource = cities.filter(func (city: Bubble): 
		return city.inventoryNew[resource_key_map[resource]]>0)
	return cities_with_resource
