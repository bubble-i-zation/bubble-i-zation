extends CharacterBody2D

const speed := 30

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var bubbles: Array[Marker2D] = []
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var current_target: Marker2D = null

func _ready() -> void:
	current_target = bubbles.pick_random()
	animated_sprite_2d.play("walk")


func _physics_process(_delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		print("target reached")
		current_target = bubbles.pick_random()
	
	animated_sprite_2d.flip_h = velocity.x < 0

	navigation_agent_2d.target_position = current_target.global_position
	var next_pos := navigation_agent_2d.get_next_path_position()
	var new_velocity := global_position.direction_to(next_pos) * speed
	
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity_forced(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	move_and_slide()
		

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
