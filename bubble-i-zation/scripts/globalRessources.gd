extends Node

#total
var pops
var mat
var food
var water
var oxygen
var fuel
#factory
var fPops
var fMat
var fFood
var fWater
var fOxygen
var fFuel
#city
var cPops
var cMat
var cFood
var cWater
var cOxygen
var cFuel


func _ready():
	repeatCheck()


func repeatCheck():
	await get_tree().create_timer(1.0).timeout
	for city in cities:
		cFood += city.inventory.filter(food) 
		cMat += city.inventory.filter(mat)
		cWater += city.inventory.filter(water)
		cOxygen += city.inventory.filter(oxygen)
		cFuel += city.inventory.filter(fuel)
		cPops += city.inventory.filter(pops)
		
	for factory in factories:
		fFood += factory.inventory.filter(food) 
		fMat += factory.inventory.filter(mat)
		fWater += factory.inventory.filter(water)
		fOxygen += factory.inventory.filter(oxygen)
		fFuel += factory.inventory.filter(fuel)
		fPops += factory.inventory.filter(pops)
		
	food = cFood + fFood
	mat = cMat + fMat
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
