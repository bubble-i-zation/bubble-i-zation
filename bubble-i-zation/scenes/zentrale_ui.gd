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

var streetBtn
var editBtn
var demolishBtn

func _ready():
	#text
	oxygenTextBox = $Oxygen/Label
	waterTextBox = $Water/Label
	foodTextBox = $Food/Label
	matsTextBox = $Material/Label
	fuelTextBox = $Fuel/Label
	popsTextBox = $Pop/Label
	
func _process(delta: float) -> void:
	food = GlobalRessources.food
	water = GlobalRessources.water
	oxygen = GlobalRessources.oxygen
	mats = GlobalRessources.matStone #zu mats ändern
	fuel = GlobalRessources.fuel
	pops = GlobalRessources.pops
	
	adjustUI()




func adjustUI():
	oxygenTextBox.text = str(oxygen)
	waterTextBox.text = str(water)
	foodTextBox.text = str(food)
	matsTextBox.text = str(mats)
	fuelTextBox.text = str(fuel)
	popsTextBox.text = str(pops)
	
