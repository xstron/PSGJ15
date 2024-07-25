extends Node
class_name HealthComponent

signal health_changed(difference: int)

@export var health: int = 100 :
	get:
		return health
	set(value):
		health_changed.emit(value - health)
		health = value
		if health <= 0:
			get_parent().queue_free()

var damage_types: Array[String] = ["Fire","Ice","Poison","Something"]

@export var damage_modifiers: Dictionary = {
	"Fire": 1.0,
	"Ice": 1.0,
	"Poison": 1.0,
	"Something": 1.0,
}

func take_damage(damage: int, type: String):
	health -= damage * damage_modifiers.get(type)
	

