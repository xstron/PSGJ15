extends CharacterBody2D
class_name Enemy

@export var health: int = 100
@export var speed: float = 50.0

@onready var nav_agent = $Pathfinding/NavigationAgent2D
@onready var animated = $AnimatedSprite2D

var target: Node2D

func _ready():
	$HealthComponent.health = health
	

func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		animated.play("default")
		return
		
	var direction = global_position.direction_to(nav_agent.get_next_path_position())
	
	if direction.x == 0:
		if direction.y == 0:
			animated.play("default")
		if direction.y < 0:
			animated.play("run_n")
		elif direction.y > 0:
			animated.play("run_s")
	elif direction.x < 0:
		if direction.y == 0:
			animated.play("run_w")
		if direction.y < 0:
			animated.play("run_nw")
		elif direction.y > 0:
			animated.play("run_sw")
	elif direction.x > 0:
		if direction.y == 0:
			animated.play("run_e")
		if direction.y < 0:
			animated.play("run_ne")
		elif direction.y > 0:
			animated.play("run_se")
	
	velocity = direction * speed
	
	move_and_slide()


func _on_detection_area_body_entered(body):
	target = body
	$Pathfinding/PathfindingUpdateTimer.start()


func _on_detection_area_body_exited(_body):
	target = null
	$Pathfinding/PathfindingUpdateTimer.stop()


func _on_pathfinding_update_timer_timeout():
	if target != null:
		nav_agent.target_position = target.global_position
	else:
		nav_agent.target_position = global_position



