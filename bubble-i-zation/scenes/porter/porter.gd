extends CharacterBody2D

const speed := 30

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var bubbles: Array[Marker2D] = []
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var bubble_bg: Sprite2D = $BubbleBG
@onready var bubble: Sprite2D = $Bubble


var current_target: Marker2D = null
var last_target: Marker2D = null

func _ready() -> void:
	current_target = bubbles.pick_random()
	last_target = current_target


func _physics_process(_delta: float) -> void:
	handle_animation()

	if current_target != null:
		do_navigation()
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func do_navigation():
	navigation_agent_2d.target_position = current_target.global_position
	var next_pos := navigation_agent_2d.get_next_path_position()
	var new_velocity := global_position.direction_to(next_pos) * speed
	
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity_forced(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)


func handle_animation():
	if velocity.length() > 0:
		animated_sprite_2d.play("walk")
		bubble.visible = true
		bubble_bg.visible = true
	else:
		animated_sprite_2d.play("idle")
		bubble.visible = false
		bubble_bg.visible = false
	
	animated_sprite_2d.flip_h = velocity.x < 0


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity


func _on_navigation_agent_2d_target_reached() -> void:
	print("target reached")
	last_target = current_target
	current_target = null
	get_tree().create_timer(2).timeout.connect(pick_new_target)

func pick_new_target():
	current_target = bubbles.pick_random()
	while current_target == last_target:
		current_target = bubbles.pick_random()
