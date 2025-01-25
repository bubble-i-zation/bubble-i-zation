class_name FlattenerJob
extends Job

# The transport job is a job that requires the NPC to pick up an item from a bubble and transport it to a destination.

var destination: Vector2
var destinationIsSet := false
var destinationIsReached := false

func execute(porter):
	if destinationIsSet == false:
		porter.navigation_agent_2d.target_position = destination
		destinationIsSet = true
		porter.targetReached.connect(func (): destinationIsReached = true)
	if destinationIsReached == true:
		isPerfomingAction = true
		Global.get_tree().create_timer(5).timeout.connect(func (): isCompleted = true)
