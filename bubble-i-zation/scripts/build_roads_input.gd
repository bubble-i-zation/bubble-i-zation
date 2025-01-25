extends Node2D

@export var road_layer: TileMapLayer

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var tile_pos := road_layer.local_to_map(road_layer.get_local_mouse_position())
		road_layer.set_cells_terrain_connect([tile_pos],0,0)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var tile_pos := road_layer.local_to_map(road_layer.get_local_mouse_position())
		road_layer.set_cells_terrain_connect([tile_pos],0,-1)
