extends Node2D
var tileMap:TileMapLayer
@export var baumaterialVerfügbar:int
@export var bauKosten = 10 #mussma halt anpassen export var icon:Texture2D
@export var animated_sprite: AnimatedSprite2D = null
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
var has_bubble := false


func _ready() -> void:
	tileMap = get_parent()

	if tileMap != null:
		grid_position = tileMap.local_to_map(global_position)
	else:
		print("TileMap für RessourceNode im Code nicht richtig benannt")
	if animated_sprite != null:
		animated_sprite.play("bubbling")

func _process(delta: float) -> void:
	checkForStreet()

func checkForStreet():
	if has_bubble:
		return
	for offset in offsets:
		var neighbor_position = grid_position + offset
		var tile_id = tileMap.get_cell_source_id(neighbor_position)
		if streetTiles.has(tile_id):
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
	if has_bubble:
		return
	var object: Node2D = scene_to_instance.instantiate()
	object.global_position = global_position
	has_bubble = true
	get_parent().get_parent().add_child(object)
	print("create bubble")

func NodeSelfKill():
	queue_free()
