extends Node2D
class_name ressource_node
var tileMap:TileMapLayer
@export var baumaterialVerfügbar:int
@export var bauKosten = 10 #mussma halt anpassen export var icon:Texture2D
@export var animated_sprite: AnimatedSprite2D = null
@export var factory := true
@export var stats: Resource
enum TYPE {living, water, oxygen, stone, wood, food, fuel}
@export var ressources:ProductionResource.ResourceType
var streetTiles = [2] # hier kommen die Tile IDs der Straße rein
var grid_position #holt koordinaten der Ressource im Grid aus world transform
var offsets = [
	Vector2i(-1, 0),
	Vector2i(1, 0),
	Vector2i(0, -1),
	Vector2i(0,1)
]
var bubbleCoroutine = false

var scene_to_instance := preload("res://scenes/bubbles/bubble.tscn")
var factory_to_instance := preload("res://scenes/bubbles/buildingMatBubble.tscn") # hier muss noch der Path von dem Factory building ran...
var bubble: Node2D = null

@export var production: ProductionResource

var inventory: Array[ProductionResource] = []
var can_produce := true



func _ready() -> void:
	if production == null:
		push_error("no pruduction for %s" % [name])
	
	
	tileMap = get_parent()

	if tileMap != null:
		grid_position = tileMap.local_to_map(global_position)
	else:
		print("TileMap für RessourceNode im Code nicht richtig benannt")
	if animated_sprite != null:
		animated_sprite.play("default")

func _process(delta: float) -> void:
	checkForStreet()
	do_production()

func do_production():
	if bubble == null:
		return
	if !can_produce:
		return
	if bubble.tier == 0:
		return
	for i in bubble.tier:
		inventory.push_back(production)
	print("produced %s %s" % [bubble.tier, production.ResourceType.keys()[production.resource_type]])
	can_produce = false
	get_tree().create_timer(5).timeout.connect(func (): can_produce = true)

func checkForStreet():
	if bubble != null:
		return
	for offset in offsets:
		var neighbor_position = grid_position + offset
		var tile_id = tileMap.get_cell_source_id(neighbor_position)
		if streetTiles.has(tile_id):
			BubbleCreation()

func BubbleCreation():
	if bubble != null:
		return
	if factory == false:
		bubble = scene_to_instance.instantiate()
		bubble.global_position = global_position
		get_parent().get_parent().add_child(bubble)
		print("create bubble")

	elif factory == true:
		
		bubble = factory_to_instance.instantiate()
		bubble.global_position = global_position
		get_parent().get_parent().add_child(bubble)
		print("create bubble")
		bubble.setRessourceType(ressources)
	if $Sprite2D != null:
		$Sprite2D.visible = false;
		 
	

func NodeSelfKill():
	queue_free()
