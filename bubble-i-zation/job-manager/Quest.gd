class_name Quest
extends RefCounted

# The quest will store a set of objectives that need to be completed.extends
var objectives: Array[Job] = []
var has_priority: bool = false
	
func add_objective(job: Job):
	objectives.push_back(job)

func get_unstarted_jobs():
	return objectives.filter(func (job: Job): return !job.isStarted)
	
func get_completed_jobs():
	return objectives.filter(func (job): return job.isCompleted == true)
# Returns the first objective in array and removes it from the array
func get_next_objective():
	var unstarted_jobs = get_unstarted_jobs()
	print("unstarted")
	print(unstarted_jobs)
	if unstarted_jobs.size() > 0:
		var job = unstarted_jobs[0]
		job.isStarted = true
		return job
	return null
	
func is_complete():
	return get_completed_jobs().size() == objectives.size()
	
func get_priority():
	return has_priority
	
func set_priority(priority: bool):
	has_priority = priority
	
