extends Node

# A quest can store multiple jobs that will be done by a single NPC one by one.

var quest_queue: Array[Quest] = []

func _ready() -> void:
	pass
	#var testQuest = Quest.new()
	#var testflattenerJob = FlattenerJob.new()
	#testflattenerJob.destination = Vector2(0, 0)
	#testQuest.add_objective(testflattenerJob)
	#add_quest(testQuest)
	
func add_quest(quest: Quest):
	quest_queue.append(quest)
	
# Returns an array of quests that are not completed and has jobs that are not in progress
func get_quests_with_unstarted_jobs() -> Array[Quest]:
	var uncompletedQuests: Array[Quest] = quest_queue.filter(func (quest): 
		return false == quest.is_complete()
	)
	
	var quests = uncompletedQuests.filter(func(quest: Quest): 
		var hasUnstartedJobs = quest.has_unstarted_jobs()
		
		return hasUnstartedJobs;
	)
	
	return quests

func get_next_quest(porter: Porter):
	var quests: Array[Quest] = get_quests_with_unstarted_jobs()
	var nextQuest: Quest = null
	
	if quests.size() == 0:
		return null
		
	# 1. Find the quest with priority
	for quest in quests:
		if quest.get_priority():
			nextQuest = quest
	
	# 2. If no job with priority, return the first quest without porter	
	if (null == nextQuest):
		var questsWithoutPorters = quests.filter(func (quest: Quest): 
			return false == quest.has_active_porter()
		)
		
		if (0 < questsWithoutPorters.size()):
			nextQuest = questsWithoutPorters[0]
		else:
			nextQuest = quests[0]
	
	if (null == nextQuest):
		return null
		
	nextQuest.add_porter(porter)
	
	return nextQuest
