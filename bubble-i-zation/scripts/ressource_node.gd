extends Node2D
@export var tileMap:TileMapLayer
@export var baumaterialVerfügbar:int
@export var bauKosten = 10 #mussma halt anpassenexport var icon:Texture2D
@export var icon:Texture2D
var streetTiles = [1,2,3,4] # hier kommen die Tile IDs der Straße rein
var grid_position = tileMap.world_to_map(global_position) #holt koordinaten der Ressource im Grid aus world transform
var offsets = [
	Vector2(-1, 0),
	Vector2(1, 0),
	Vector2(0, -1),
	Vector2(0,1)
]
var bubbleCoroutine = false
	
func checkForStreet(bool):
	for offset in offsets:
		var neighbor_position = grid_position + offset
		var tile_id = tileMap.get_cellv(neighbor_position)
		if tile_id == streetTiles:
			coroutineBubbleCreation()
			bubbleCoroutine = true
			return true
		else:
			return false
#Damit nicht jeden Frame versucht wird, zu bauen			
func coroutineBubbleCreation():
	if bubbleCoroutine == true:
		await get_tree().create_timer(1.0)
		tryBubbleCreation()
		coroutineBubbleCreation()
	else:
		return
	
func tryBubbleCreation():
	if baumaterialVerfügbar >= bauKosten:
		
		#start Quest -> nach abschluss soll func BubbleCreation triggern
		return
		#print.log("Quest sollt starten, und do muss was in der if sein, daher der text")
func BubbleCreation():
	#Sprite austauschen,...
	#print.log("Bubble sollt jetz do si")
	bubbleCoroutine = false
	return
