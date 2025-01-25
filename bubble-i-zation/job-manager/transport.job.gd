class_name TransportJob
extends Job

# The transport job is a job that requires the NPC to pick up an item from a bubble and transport it to a destination.

var item_to_transport: Object = null
var destination: Vector2

func execute(porter):
	pass
	# 1. Find the bubble with the item
	# 2. Walk to the bubble
	# 3. Pick up the item
	# 4. Walk to the destination
	# 5. Drop the item
	# 6. Finish the job
