extends Control

var food:int = 0
var water:int = 0
var oxygen:int = 0
var mats:int = 0
var fuel:int = 0
var pops:int = 0

var oxygenTextBox
var waterTextBox 
var foodTextBox
var matsTextBox
var fuelTextBox
var popsTextBox

var streetBtn
var editBtn
var demolishBtn

func _ready():
	#text
	oxygenTextBox = $Oxygen/RichTextLabel
	waterTextBox = $Water/RichTextLabel2
	foodTextBox = $Food/RichTextLabel
	matsTextBox = $Material/RichTextLabel
	fuelTextBox = $FuelNoImage/RichTextLabel
	popsTextBox = $PopsNoImage/RichTextLabel
	#buttons
	streetBtn = $Control/streetBtn
#	streetBtn.pressed.connect("pressed", streetBtnPressed())
	editBtn = $Control/editBtn
#	editBtn.pressed.connect("pressed", editBtnPressed())
	demolishBtn = $Control/demolishBtn
#	demolishBtn.pressed.connect("pressed", demolishBtnPressed())
	
func _process(delta: float) -> void:
	food = GlobalRessources.food
	water = GlobalRessources.water
	oxygen = GlobalRessources.oxygen
	mats = GlobalRessources.matStone #zu mats ändern
	fuel = GlobalRessources.fuel
	pops = GlobalRessources.pops

func adjustUI():
	oxygenTextBox.text = oxygen
	waterTextBox.text = water
	foodTextBox.text = food
	matsTextBox.text = mats
	fuelTextBox.text = fuel
	popsTextBox.text = pops
	
#	func streetBtnPressed():
		
		
#	func editBtnPressed():
		
		
#	func demolishBtnPressed():
		
		
	
	
	
	
	
