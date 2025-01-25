extends Button

func _ready():
	pressed.connect(_on_pressed)  # Auto-connect the signal

func _on_pressed():
	get_tree().quit()
