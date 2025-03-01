extends CharacterBody2D
class_name Porter

const speed := 30

@onready var porter_audio_player = $AudioStreamPlayer2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var work_particles: GPUParticles2D = $WorkParticles

@export var bubbles: Array[Marker2D] = []
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var bubble_bg: Sprite2D = $BubbleBG
@onready var bubble: Sprite2D = $Bubble

@onready var porter_speech_bubble: PorterSpeechBubble = $PorterSpeechBubble

var current_job: Job = null
var inventory: Array[ProductionResource.ResourceType] = []

signal targetReached
#spaß mit blasen

func _process(_delta: float) -> void:	
	if current_job == null:
		current_job =  QuestManager.get_next_job(self)
	#if current_job != null:
		#print("got new job")
		#print(current_job)
		#print("got new job fail count: ",current_job.jobFailedCount)
	
	if (current_job != null && current_job.jobFailedCount < 5):
		#print("execute job: ",current_job)
		current_job.execute(self)
		if (current_job.isCompleted):
			print("current_job is completed: ",current_job)
			current_job = null
	else:
		current_job = null
	handle_speech_bubble()

func _physics_process(_delta: float) -> void:
	handle_animation()
	do_navigation()
	move_and_slide()


func handle_speech_bubble():
	if current_job == null:
		porter_speech_bubble.reset()
		return
	
	if !navigation_agent_2d.is_target_reachable():
		porter_speech_bubble.show_road(true)
		return
	
	if current_job is FlattenerJob:
		porter_speech_bubble.show_flatten()
	
	if current_job is TransportJob:
		porter_speech_bubble.show_resource_type(current_job.resourceType, !current_job.found_item)


func do_navigation():
	if current_job == null || current_job.isPerfomingAction:
		velocity = Vector2.ZERO
		return

	if !navigation_agent_2d.is_target_reachable():
		velocity = Vector2.ZERO
		return
	
	if current_job is TransportJob && !current_job.found_item:
		velocity = Vector2.ZERO
		return

	var next_pos := navigation_agent_2d.get_next_path_position()
	var new_velocity := global_position.direction_to(next_pos) * speed
	
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity_forced(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)

func handle_animation():
	work_particles.emitting = false
	
	if velocity.length() > 0:
		animated_sprite_2d.play("walk")
	elif current_job != null && current_job.isPerfomingAction:
		animated_sprite_2d.play("work")
		porter_audio_player.play()
		work_particles.emitting = true
	else:
		animated_sprite_2d.play("idle")

	animated_sprite_2d.flip_h = velocity.x < 0


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity

func _on_navigation_agent_2d_target_reached() -> void:
	print("target reached")
	targetReached.emit()
	
func add_item(item: ProductionResource.ResourceType) -> void:
	inventory.append(item)
	
func remove_item(item: ProductionResource.ResourceType) -> void:
	inventory.erase(inventory.find(item))
