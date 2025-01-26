extends Node2D

@export var road_layer: TileMapLayer

var construction_quests: Dictionary = {}

func construct_road(tile_pos: Vector2i):
	road_layer.set_cell(tile_pos,7, Vector2i(0,0))
	var quest := Quest.new()
	var job := TransportJob.new()
	var local_pos := road_layer.map_to_local(tile_pos)
	var job_site := local_pos + road_layer.global_position
	print(job_site)
	job.destination = job_site
	job.resourceType = ProductionResource.ResourceType.BaumMatsWood
	quest.add_objective(job)
	QuestManager.add_quest(quest)
	
	construction_quests[tile_pos] = quest

func remove_road(tile_pos: Vector2i):
	road_layer.set_cells_terrain_connect([tile_pos],0,-1)

	if construction_quests.has(tile_pos):
		var existing_quest: Quest = construction_quests[tile_pos]
		for objective in existing_quest.objectives:
			objective.isAborted = true
		construction_quests.erase(tile_pos)


func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var tile_pos := road_layer.local_to_map(road_layer.get_local_mouse_position())
		var id := road_layer.get_cell_source_id(tile_pos)
		if id != -1:
			return
		construct_road(tile_pos)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var tile_pos := road_layer.local_to_map(road_layer.get_local_mouse_position())
		var id := road_layer.get_cell_source_id(tile_pos)
		if !(id == 2 || id == 3 || id == 7):
			return
		remove_road(tile_pos)


func _on_timer_timeout() -> void:
	for key in construction_quests:
		var quest: Quest = construction_quests[key]
		if quest.is_complete():
			road_layer.set_cells_terrain_connect([key],0,0)
			construction_quests.erase(key)
