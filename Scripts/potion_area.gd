extends Node2D
class_name PotionArea

@export var radius: float = 128.0
@export var duration: float = 3.0

func _ready():
	($AttackComponent/CollisionShape2D.shape as CircleShape2D).radius = radius
	$DurationTimer.start(duration)


func _on_duration_timer_timeout():
	queue_free()


func _on_tick_timer_timeout():
	for area in $AttackComponent.get_overlapping_areas():
		var hitbox: HitboxComponent = area as HitboxComponent
		if hitbox.health_component != null:
			hitbox.health_component.take_damage($AttackComponent.damage, "Poison")
