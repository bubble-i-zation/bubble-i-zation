extends Node2D

@export var road_layer: TileMapLayer

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
			var tile_pos := road_layer.local_to_map(road_layer.get_local_mouse_position())
			print(tile_pos)
			road_layer.set_cells_terrain_connect([tile_pos],0,0)
