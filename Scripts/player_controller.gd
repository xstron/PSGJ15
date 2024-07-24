extends CharacterBody2D
class_name Player

@export var speed: float = 100
@export var health: int = 5


const POTION_AREA_SCENE: PackedScene = preload("res://Scenes/potion_area.tscn")

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
		if selected_potion >= 0:
			var potion_area = POTION_AREA_SCENE.instantiate()
			potion_area.set_position(get_global_mouse_position())
			%PotionAreas.add_child(potion_area)
	if event.is_action_pressed("Secondary"):
		selected_potion = -1
		
	if event.is_action_pressed("Interact"):
		if interaction_current != null:
			interaction_current.interact()

func _draw():
	if draw_potion_hint:
		draw_arc(get_global_mouse_position() - global_position, 32.0, 0.0 * PI, 2.0 * PI, 100, Color.CORNFLOWER_BLUE, -1.0, false)


func _on_interaction_area_area_exited(area):
	(area as InteractionComponent).icon_hide()


func _on_hitbox_area_entered(area):
	if area.name == "Hitbox":
		health -= 1
		if health >= 0: 
			print(health)
