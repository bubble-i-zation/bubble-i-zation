class_name FlattenerJob
extends Job

# The transport job is a job that requires the NPC to pick up an item from a bubble and transport it to a destination.

var item_to_transport: Object = null
var destination: Vector2
var destinationIsSet := false
var destinationIsReached := false

func execute(porter):
	if destinationIsSet == false:
		porter.navigation_agent_2d.target_position = destination
		destinationIsSet = true
		print("destination is Set")
		porter.targetReached.connect(func (): destinationIsReached = true)
	if destinationIsReached == true:
		print("Target Reached")
		get_tree().create_timer(2).timeout.connect(func (): isCompleted = true)
	if isCompleted:
		print ("job completed")
		
		
	
	
	
	
	
	pass
	# 1. Find the bubble with the item
	# 2. Walk to the bubble
	# 3. Pick up the item
	# 4. Walk to the destination
	# 5. Drop the item
	# 6. Finish the job
