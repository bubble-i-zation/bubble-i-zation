extends Button

var next_scene_path : String = "res://scenes/example_world.tscn"  # Add this line to define the exported variable

func _ready():
	if next_scene_path != "":
		pressed.connect(_on_pressed)  # Auto-connect the signal

func _on_pressed():
	get_tree().change_scene_to_file(next_scene_path)
