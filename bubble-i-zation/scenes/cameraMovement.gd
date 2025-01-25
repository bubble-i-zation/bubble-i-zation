extends Camera2D

var maxSpeed = 400
var speed = 1
var acceleration = 24
var move_direction = Vector2(0,0)
var motion
#zoom
var currentZoom
var newZoom
var zoomSpeed = 10
var zoomMargin = 0.1
var zoomMin = 1
var zoomMax = 3
var zoomfactor = 1


func _ready():
	currentZoom = zoom
func _process(delta: float) -> void:
	movementLoop(delta)
	position += motion
	#zoom
	
	zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomSpeed * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomSpeed * delta)
	
	zoom.x = clamp(zoom.x, zoomMin, zoomMax)
	zoom.y = clamp(zoom.y, zoomMin, zoomMax)
	
func _input(event):
	if (Input.is_action_pressed("Zoom-Out")):
		zoomfactor -= 0.1
		if zoomfactor < 0:
			zoomfactor = 0
	if (Input.is_action_pressed("Zoom-In")):
		zoomfactor += 0.1
		if zoomfactor > 1:
			zoomfactor = 1
	
func movementLoop(delta):
	move_direction.x = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	move_direction.y = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up")) / float(2)
	if move_direction != Vector2(0,0):
		speed += acceleration * delta
	else:
		speed = 1
	motion = move_direction.normalized() * speed
