class_name TransportJob
extends Job

# The transport job is a job that requires the NPC to pick up an item from a bubble and transport it to a destination.

enum jobState {
	SEARCH_ITEM,
	WALK_TO_ITEM,
	ON_WAY_TO_ITEM,
	PICK_UP_ITEM,
	WALK_TO_DESTINAION,
	ON_WAY_TO_DESTINATION,
	DROP_ITEM,
	FINISH_JOB,
	JOB_FAILED
}

var current_state: jobState = jobState.SEARCH_ITEM;
var item_to_transport: Object = null
var destination: Vector2
var resourceType: ProductionResource.ResourceType
var factory: ressource_node
var city: Bubble
var destinationCity: Bubble
var found_item := false
var urgency = 0

func _init(newUrgency: int = 0):
	urgency = newUrgency

func execute(porter):
	#print("Current state: " + str(current_state))
	match current_state:
		jobState.SEARCH_ITEM:
			# Find the bubble with the item
			var factories: Array[ressource_node] = GlobalRessources.get_factories(resourceType)
			var cities: Array[Bubble] = GlobalRessources.get_cities(resourceType)
			cities = cities.filter(func(city):return city != destinationCity)
			#print("factories")
			#print(factories.size())
			if factories.size() == 0 and cities.size() == 0:
		 	# No factory found
				current_state = jobState.JOB_FAILED
			else:
				if factories.size() != 0 && factories[0].tier > 0 && urgency > 0:
					factory = factories[0]
					current_state = jobState.WALK_TO_ITEM
				elif cities.size() != 0:
					city = cities[0]
					current_state = jobState.WALK_TO_ITEM
				
		jobState.WALK_TO_ITEM:
			found_item = true
			# Walk to the bubble
#			porter.targetReached.connect(func (): current_state = jobState.PICK_UP_ITEM)
			porter.targetReached.connect(on_target_reached)
			if factory != null:
				porter.navigation_agent_2d.target_position = factory.position
			else:
				if city != null:
					porter.navigation_agent_2d.target_position = city.position
			
			current_state = jobState.ON_WAY_TO_ITEM
			
		jobState.PICK_UP_ITEM:
			# Pick up the item
			# @todo: Remove the item from the bubble
			if factory != null:
				factory.remove_resource(resourceType)
			elif city != null:
				city.remove_resource(resourceType)
			porter.add_item(resourceType)
			current_state = jobState.WALK_TO_DESTINAION
			
		jobState.WALK_TO_DESTINAION:
			# Walk to the destination
			porter.targetReached.connect(func (): current_state = jobState.DROP_ITEM)
			porter.navigation_agent_2d.target_position = destination
			current_state = jobState.ON_WAY_TO_DESTINATION

		jobState.DROP_ITEM:
			# Drop the item
			if destinationCity:
				destinationCity.add_resource(resourceType)
			porter.remove_item(resourceType)
			current_state = jobState.FINISH_JOB
			isPerfomingAction = true

		jobState.FINISH_JOB:
			# Finish the job
			Global.get_tree().create_timer(3).timeout.connect(on_finish_timeout)

		jobState.JOB_FAILED:
			current_state = jobState.SEARCH_ITEM


func on_finish_timeout():
	isCompleted = true
	isPerfomingAction = false

func on_target_reached():
	isPerfomingAction = true
	Global.get_tree().create_timer(2).timeout.connect(on_target_action_done)

func on_target_action_done():
	isPerfomingAction = false
	current_state = jobState.PICK_UP_ITEM
