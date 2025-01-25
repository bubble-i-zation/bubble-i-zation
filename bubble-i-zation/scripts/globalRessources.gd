extends Node

#total
var pops := 0
var matStone := 0
var matWood := 0
var food := 0
var water := 0
var oxygen := 0
var fuel := 0


func _process(delta: float) -> void:
	repeatCheck()


func repeatCheck():
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
		cFood += city.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Food).size()
		cMatStone += city.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.BauMatsStone).size()
		cMatWood += city.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.BaumMatsWood).size()
		cWater += city.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Water).size()
		cOxygen += city.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Oxygen).size()
		cFuel += city.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Brennstoff).size()
		cPops += city.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Population).size()
		
	for factory in factories:
		fFood += factory.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Food).size()
		fMatStone += factory.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.BauMatsStone).size()
		fMatWood += factory.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.BaumMatsWood).size()
		fWater += factory.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Water).size()
		fOxygen += factory.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Oxygen).size()
		fFuel += factory.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Brennstoff).size()
		fPops += factory.inventory.filter(func (item: ProductionResource): return item.resource_type == ProductionResource.ResourceType.Population).size()
		
	food = cFood + fFood
	matStone = cMatStone + fMatStone
	matWood = cMatWood + fMatWood
	water = cWater + fWater
	oxygen = cOxygen + fOxygen
	fuel = cFuel + fFuel
	pops = cPops + fPops


var cities: Array[ressource_node] = []
var factories: Array[ressource_node] = []

func add_to_cities (ressourceNode:ressource_node):
	cities.append(ressourceNode)
	
func add_to_factories (ressourceNode:ressource_node):
	factories.append(ressourceNode)
