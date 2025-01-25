extends CharacterBody2D

const speed := 30

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export var bubbles: Array[Marker2D] = []
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var bubble_bg: Sprite2D = $BubbleBG
@onready var bubble: Sprite2D = $Bubble


var current_target: Marker2D = null
var last_target: Marker2D = null

var current_quest: Quest = null
var current_job: Job = null

func _ready() -> void:
	current_target = bubbles.pick_random()
	navigation_agent_2d.target_position = current_target.global_position
	last_target = current_target
	animated_sprite_2d.play("walk")
	
	# Example how to use the quest system
	var transportJob = TransportJob.new()
	var buildJob = BuildJob.new()
	var quest = Quest.new()
	quest.add_objective(transportJob)
	quest.add_objective(buildJob)
	
	QuestManager.add_quest(quest)
	# Example how to use the quest system end

func _process(_delta: float) -> void:
	# Example how to use the quest system
	if (current_quest == null):
		current_quest = QuestManager.get_next_quest()
		print("got new quest")
		print(current_quest)
		
	if (current_quest != null and current_job == null):
		current_job = current_quest.get_next_objective()
		print("got new job")
		print(current_job)
	
	if (current_job != null):
		current_job.execute()

func _physics_process(_delta: float) -> void:
	handle_animation()
	do_navigation()
	move_and_slide()


func do_navigation():
	if current_target == null:
		velocity = Vector2.ZERO
		return

	if !navigation_agent_2d.is_target_reachable():
		velocity = Vector2.ZERO
		return

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
	navigation_agent_2d.target_position = current_target.global_position
