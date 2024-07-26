extends CharacterBody2D
class_name Player

@export var speed: float = 100
@export var health: float = 50
@export var max_cast_distance: float = 50
@onready var current_health = health 
@onready var health_progress = 0


@onready var animated = $AnimatedSprite2D

const POTION_AREA_SCENE: PackedScene = preload("res://Scenes/potion_area.tscn")
var can_cast: bool = true

var draw_potion_hint: bool = false
var selected_potion: int = -1 :
	set(value):
		if value >= 0:
			draw_potion_hint = true
		else:
			draw_potion_hint = false
		queue_redraw()
		selected_potion = value

@onready var interaction_area = $InteractionArea
var interaction_current: InteractionComponent = null

func _ready():
	$HealthComponent.health = health

	
func _process(_delta: float):
	pass

func _physics_process(_delta: float):
	var areas: Array[Area2D] = interaction_area.get_overlapping_areas()
	if areas.size() > 0:
		areas.sort_custom(func(a: Node2D, b: Node2D): return a.global_position.distance_squared_to(global_position) < b.global_position.distance_squared_to(global_position))
		interaction_current = areas[0]
		interaction_current.icon_show()
		for area in areas.slice(1):
			(area as InteractionComponent).icon_hide()
	else:
		interaction_current = null
	
	var direction: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")

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

func _input(event: InputEvent):
	if event.is_action_pressed("Spell 1"):
		selected_potion = 0
	if event.is_action_pressed("Spell 2"):
		selected_potion = 1
	if event.is_action_pressed("Spell 3"):
		selected_potion = 2
	if event.is_action_pressed("Spell 4"):
		selected_potion = 3
	
	if event is InputEventMouseMotion:
		queue_redraw()
		
	if event.is_action_pressed("Primary"):
		if selected_potion >= 0 and can_cast:
			var potion_area = POTION_AREA_SCENE.instantiate()
			var pos = get_global_mouse_position()
			var rel_pos = pos - global_position
			if rel_pos.length() > max_cast_distance:
				pos = global_position+  rel_pos.normalized() * max_cast_distance
			potion_area.set_position(pos)
			%PotionAreas.add_child(potion_area)
			can_cast = false
			$SpellTimer.start()
	if event.is_action_pressed("Secondary"):
		selected_potion = -1
		
	if event.is_action_pressed("Interact"):
		if interaction_current != null:
			interaction_current.interact()

func _draw():
	if draw_potion_hint:
		var pos = get_global_mouse_position() - global_position
		if pos.length() > max_cast_distance:
			pos = pos.normalized() * max_cast_distance
		draw_arc(pos, 32.0, 0.0 * PI, 2.0 * PI, 100, Color.WEB_PURPLE, 1.0, false)


func _on_interaction_area_area_exited(area):
	(area as InteractionComponent).icon_hide()




func _on_hitbox_component_area_entered(area):
	if area.name == "HitboxComponent":
		current_health -= 1
		health_progress += 1
		$HealthBar.set_value(health_progress)
		if current_health >= 0: 
			print(current_health)



func _on_spell_timer_timeout():
	can_cast = true
