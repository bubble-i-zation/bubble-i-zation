extends Node

#total
var pops := 0
var matStone := 0
var matWood := 0
var food := 0
var water := 0
var oxygen := 0
var fuel := 0
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


func _ready():
	repeatCheck()


func repeatCheck():
	await get_tree().create_timer(1.0).timeout
	for city in cities:
		cFood += city.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Food) 
		cMatStone += city.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.BauMatsStone)
		cMatWood += city.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.BaumMatsWood)
		cWater += city.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Water)
		cOxygen += city.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Oxygen)
		cFuel += city.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Brennstoff)
		cPops += city.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Population)
		
	for factory in factories:
		fFood += factory.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Food)
		fMatStone += factory.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.BauMatsStone)
		fMatWood += factory.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.BaumMatsWood)
		fWater += factory.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Water)
		fOxygen += factory.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Oxygen)
		fFuel += factory.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Brennstoff)
		fPops += factory.inventory.count(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Population)
		
	food = cFood + fFood
	matStone = cMatStone + fMatStone
	matWood = cMatWood + fMatWood
	water = cWater + fWater
	oxygen = cOxygen + fOxygen
	fuel = cFuel + fFuel
	pops = cPops + fPops
	repeatCheck()


var cities: Array[ressource_node] = []
var factories: Array[ressource_node] = []

func add_to_cities (ressourceNode:ressource_node):
	cities.append(ressourceNode)
	
func add_to_factories (ressourceNode:ressource_node):
	factories.append(ressourceNode)
