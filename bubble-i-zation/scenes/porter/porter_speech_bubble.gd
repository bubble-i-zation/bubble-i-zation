extends Node2D

class_name PorterSpeechBubble

@onready var flatten_speech_bubble: Sprite2D = $FlattenSpeechBubble
@onready var nope_sprite: Sprite2D = $Nope
@onready var street_speech_bubble: Sprite2D = $StreetSpeechBubble
@onready var o_2_speech_bubble: Sprite2D = $O2SpeechBubble
@onready var water_speech_bubble: Sprite2D = $WaterSpeechBubble
@onready var building_mat_speech_bubble: Sprite2D = $BuildingMatSpeechBubble
@onready var food_speech_bubble: Sprite2D = $FoodSpeechBubble

var all_sprites: Array[Sprite2D] = []


func _ready() -> void:
	for child in get_children():
		if child is Sprite2D:
			all_sprites.push_back(child)
	
	reset()


func reset():
	for sprite in all_sprites:
		sprite.visible = false


func show_nope(visible: bool):
	nope_sprite.visible = visible


func show_flatten(nope: bool = false):
	reset()
	flatten_speech_bubble.visible = true
	show_nope(nope)

func show_road(nope: bool = false):
	reset()
	street_speech_bubble.visible = true
	show_nope(nope)

func show_resource_type(resource: ProductionResource.ResourceType, nope: bool = false):
	reset()
	show_nope(nope)
	if resource == ProductionResource.ResourceType.Oxygen:
		o_2_speech_bubble.visible = true
	elif resource == ProductionResource.ResourceType.Water:
		water_speech_bubble.visible = true
	elif resource == ProductionResource.ResourceType.BauMatsStone || resource == ProductionResource.ResourceType.BaumMatsWood:
		building_mat_speech_bubble.visible = true
	elif resource == ProductionResource.ResourceType.Food:
		food_speech_bubble.visible = true
		
