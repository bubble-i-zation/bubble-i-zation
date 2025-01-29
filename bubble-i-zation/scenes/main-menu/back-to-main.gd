extends Button

var next_scene_path : String = "res://scenes/main-menu/main-menu.tscn"  # Add this line to define the exported variable

func _on_pressed():
	get_tree().change_scene_to_file(next_scene_path)
