extends Control

var food:int = 0
var water:int = 0
var oxygen:int = 0
var mats:int = 0
var fuel:int = 0
var pops:int = 0

var oxygenTextBox: Label
var waterTextBox: Label
var foodTextBox: Label
var matsTextBox: Label
var fuelTextBox: Label
var popsTextBox: Label

var inventory:ProductionResource.ResourceType
var parentObj:Node2D
var nodeInUse:bool = false


func _ready() -> void:	
	parentObj = get_parent()
	oxygenTextBox = $TextureRect/Oxygen/Label
	waterTextBox = $TextureRect/Water/Label
	foodTextBox = $TextureRect/Food/Label
	matsTextBox = $TextureRect/Material/Label
	fuelTextBox = $TextureRect/Fuel/Label
	popsTextBox = $TextureRect/Pop/Label

func turnVisible(istrue):
	self.visible =istrue
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("showInventory"):
		if nodeInUse == true:
			turnVisible(true)
	else:
		turnVisible(false)
		
		
	
	food = parentObj.inventoryNew["Food"]
	water = parentObj.inventoryNew["Water"]
	oxygen = parentObj.inventoryNew["Oxygen"]
	mats = parentObj.inventoryNew["BaumMatsWood"]
	fuel = parentObj.inventoryNew["Brennstoff"]
	pops = parentObj.inventoryNew["Population"]
	#Labels
	oxygenTextBox.text = str(oxygen)
	waterTextBox.text = str(water)
	foodTextBox.text = str(food)
	matsTextBox.text = str(mats)
	fuelTextBox.text = str(fuel)
	popsTextBox.text = str(pops)
