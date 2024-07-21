extends CharacterBody2D
class_name Enemy

@export var health: int = 100

func _ready():
	$HealthComponent.health = health
