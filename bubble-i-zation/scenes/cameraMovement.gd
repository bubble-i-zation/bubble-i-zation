extends Camera2D

const speed := 10

var currentZoom: float
var zoomMin := 1
var zoomMax := 5
var zoom_target: float

func _ready():
	currentZoom = zoom.x
	zoom_target = zoom.x

func _process(delta: float) -> void:
	move_camera()

	if Input.is_action_just_pressed("Zoom-In") && zoom_target < zoomMax:
		zoom_target += 0.5
	if Input.is_action_just_pressed("Zoom-Out") && zoom_target > zoomMin:
		zoom_target -= 0.5
	
	currentZoom = lerpf(currentZoom, zoom_target, 8 * delta)
	zoom = Vector2(currentZoom, currentZoom)

func move_camera():
	var move_direction := Vector2(0,0)
	move_direction.x = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	move_direction.y = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up")) / float(2)

	var motion = move_direction.normalized() * speed * (1 / currentZoom)
	
	position += motion
