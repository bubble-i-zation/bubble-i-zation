class_name Quest
extends RefCounted

# The quest will store a set of objectives that need to be completed.extends
var objectives: Array = []
var has_priority: bool = false
	
func add_objective(job: Job):
	objectives.push_back(job)

# Returns the first objective in array and removes it from the array
func get_next_objective():
	if objectives.size() > 0:
		var job = objectives[0]
		objectives.erase(0)
		return job
	return null
	
func is_complete():
	return objectives.size() == 0
	
func get_priority():
	return has_priority
	
func set_priority(priority: bool):
	has_priority = priority
	
