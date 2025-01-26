extends Node2D
class_name ressource_node
var tileMap:TileMapLayer
@onready var construction_audio_player = $ConstructionAudioStreamPlayer
@onready var resource_audio_player = $ResourceAudioStreamPlayer
@onready var bubblepop_audio_player = $BubblePopAudioStreamPlayer
@export var bauKosten = 10 #mussma halt anpassen export var icon:Texture2D
@export var animated_sprite: AnimatedSprite2D = null
@export var factory := true
@export var stats: Resource
@export var ressources:ProductionResource.ResourceType
var streetTiles = [2] # hier kommen die Tile IDs der Straße rein
var grid_position #holt koordinaten der Ressource im Grid aus world transform
var offsets = [
	Vector2i(-1, 0),
	Vector2i(1, 0),
	Vector2i(0, -1),
	Vector2i(0,1)
]
var diaOffsets = [
	Vector2i(1, 1),
	Vector2i(-1, 1),
	Vector2i(-1, -1),
	Vector2i(1, -1)
]

var plotsToFlatten: Array [Vector2i] = []

var bubbleCoroutine = false

var jobs: Array [FlattenerJob] = []
var scene_to_instance := preload("res://scenes/bubbles/bubble.tscn")
var factory_to_instance := preload("res://scenes/bubbles/buildingMatBubble.tscn") # hier muss noch der Path von dem Factory building ran...
var bubble: Node2D = null

@export var production: ProductionResource

@export var inventoryNew = {
	BauMatsStone = 0,
	BaumMatsWood = 0,
	Brennstoff = 0,
	Food = 0,
	Oxygen = 0,
	Water = 0,
	Population = 0
}
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
	if jobs.size() > 0 && jobs.filter(func (job:Job): return job.isCompleted).size() == jobs.size():
		BubbleCreation()

func do_production():
	if bubble == null:
		return
	if !can_produce:
		return
	if bubble.tier == 0:
		return
	for i in bubble.tier:
		
		inventoryNew[GlobalRessources.resource_key_map[production.resource_type]] += 1
		print("inventoryNew: ",inventoryNew)
	print("produced %s %s" % [bubble.tier, production.ResourceType.keys()[production.resource_type]])
	can_produce = false
	get_tree().create_timer(5).timeout.connect(func (): can_produce = true)

func checkForStreet():
	var beganTiling := false
	if bubble != null:
		return
	for offset in offsets:
		var neighbor_position = grid_position + offset
		if neighbor_position not in plotsToFlatten:
			plotsToFlatten.append(neighbor_position)
		var tile_id = tileMap.get_cell_source_id(neighbor_position)
		if streetTiles.has(tile_id) && beganTiling == false:
			#plotsToFlatten.remove_at(streetTiles.has(tile_id)) # verbesserungspotenzial für keine Straßen flatten
			beganTiling = true
			for diaOffset in diaOffsets:
				var diaNeighbor_position = grid_position + diaOffset
				if diaNeighbor_position not in plotsToFlatten:
					plotsToFlatten.append(diaNeighbor_position)
			BeginTiling()
			
		
		
func BeginTiling():
	
	if jobs.size() > 0:
		return
	var tilingPositions: Array [Vector2]
	for surrounding_cell in plotsToFlatten:
		var local_position = tileMap.map_to_local(surrounding_cell)
		var global_Pos = local_position + tileMap.global_position
		tilingPositions.push_back(global_Pos)
	
	var flattenerQuest = Quest.new()
	
	for tile in tilingPositions:
		var flattenerJob = FlattenerJob.new()
		flattenerJob.gimmeYourTILES(tileMap)
		jobs.push_back(flattenerJob)
		print("created Job")
		flattenerJob.destination = tile
		var targetLocation = flattenerJob.destination
		flattenerJob.gimmeYourSpots(targetLocation)
		flattenerQuest.add_objective(flattenerJob)
	QuestManager.add_quest(flattenerQuest)
	construction_audio_player.play()
	


func BubbleCreation():
	if bubble != null:
		return
	if factory == false:
		bubble = scene_to_instance.instantiate()
		bubble.global_position = global_position
		get_parent().get_parent().add_child(bubble)
		print("create bubble")
		bubblepop_audio_player.play()
		
		

	elif factory == true:
		
		bubble = factory_to_instance.instantiate()
		GlobalRessources.add_to_factories(self)
		bubble.global_position = global_position
		get_parent().get_parent().add_child(bubble)
		print("create bubble")
		bubble.setRessourceType(ressources)
		bubblepop_audio_player.play()
		
		
func NodeSelfKill():
	
	queue_free()

func remove_resource(resource:ProductionResource.ResourceType, quantity = 1):
	inventoryNew[GlobalRessources.resource_key_map[resource]] -= quantity
