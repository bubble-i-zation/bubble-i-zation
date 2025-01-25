extends Node

# A quest can store multiple jobs that will be done by a single NPC one by one.

var quest_queue: Array = []

func _ready() -> void:
	var testQuest = Quest.new()
	var testflattenerJob = FlattenerJob.new()
	testflattenerJob.destination = Vector2(0, 0)
	testQuest.add_objective(testflattenerJob)
	add_quest(testQuest)
	
func add_quest(quest: Quest):
	quest_queue.append(quest)

func get_next_quest():
	if quest_queue.size() == 0:
		return null
		
	# 1. Find the quest with priority
	for quest in quest_queue:
		if quest.get_priority():
			return quest
	
	# 2. If no job with priority, return the first job
	return quest_queue.pop_front()
