extends Node2D
@export var tileMap:TileMapLayer
@export var baumaterialVerfügbar:int
@export var bauKosten = 10 #mussma halt anpassen export var icon:Texture2D
var streetTiles = [2] # hier kommen die Tile IDs der Straße rein
var grid_position #holt koordinaten der Ressource im Grid aus world transform
var offsets = [
	Vector2(-1, 0),
	Vector2(1, 0),
	Vector2(0, -1),
	Vector2(0,1)
]
var bubbleCoroutine = false
var scene_to_instance = preload("res://scenes/bubbles/bubble.tscn")


func _ready() -> void:
	
	tileMap = $TileMapLayer #weist die TileMap automatisch zu
	if tileMap != null:
		grid_position = tileMap.local_to_map(global_position)
	else:
		print("TileMap für RessourceNode im Code nicht richtig benannt")
	if $AnimatedSprite2D != null:
		$AnimatedSprite2D.play("bubbling")
		
func checkForStreet():
	for offset in offsets:
		var neighbor_position = grid_position + offset
		var tile_id = tileMap.get_cellv(neighbor_position)
		if tile_id == streetTiles:
			#coroutineBubbleCreation()
			#bubbleCoroutine = true
			BubbleCreation()
			
#Damit nicht jeden Frame versucht wird, zu bauen			
#func coroutineBubbleCreation():
	#if bubbleCoroutine == true:
		#await get_tree().create_timer(1.0)
		#tryBubbleCreation()
		#coroutineBubbleCreation()
	#else:
		#return
	
#func tryBubbleCreation():
	#if baumaterialVerfügbar >= bauKosten:
		#BubbleCreation()
		#return
		
func BubbleCreation():
	var object = scene_to_instance.instance()
	# bubbleCoroutine = false
	return

func NodeSelfKill():
	queue_free()
