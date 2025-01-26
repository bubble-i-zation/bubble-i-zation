class_name FlattenerJob
extends Job
var tileMap:TileMapLayer
# The transport job is a job that requires the NPC to pick up an item from a bubble and transport it to a destination.

var destination: Vector2
var destinationIsSet := false
var destinationIsReached := false
var grid_position:Vector2
var world_Pos:Vector2
var determinedLocation


func gimmeYourTILES(tilesss:TileMapLayer):
	tileMap = tilesss
	
func gimmeYourSpots(tileLocation:Vector2):
	determinedLocation = tileLocation

func _ready():
	grid_position = tileMap.local_to_map(determinedLocation)
	world_Pos = grid_position + determinedLocation
	print(grid_position)
	
func execute(porter):
	if destinationIsSet == false:
		porter.navigation_agent_2d.target_position = destination
		destinationIsSet = true
		porter.targetReached.connect(func (): destinationIsReached = true)
	if destinationIsReached == true:
		isPerfomingAction = true
		Global.get_tree().create_timer(5).timeout.connect(func (): isCompleted = true)
		#var tilePos = tileMap.local_to_map(destination)
		#var global_Pos = destination + tilePos
		grid_position = tileMap.local_to_map(determinedLocation)
		world_Pos = grid_position + determinedLocation
		tileMap.set_cell(grid_position, 5, Vector2(4,0), 0) #irgendwie hots doch no oan sinn gehabt
