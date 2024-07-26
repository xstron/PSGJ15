extends Node2D
class_name PotionArea

@export var radius: float = 128.0
@export var duration: float = 3.0

func _ready():
	($AttackComponent/CollisionShape2D.shape as CircleShape2D).radius = radius
	$DurationTimer.start(duration)

func _draw():
	var pos = Vector2(0.0, 0.0)
	draw_arc(pos, radius, 0.0*PI, 2.0*PI, 100, Color(0.501961, 0, 0.501961, 0.5), 1, false)
	draw_circle(pos, radius, Color(0.501961, 0, 0.501961, 0.25))

func _on_duration_timer_timeout():
	queue_free()


func _on_tick_timer_timeout():
	for area in $AttackComponent.get_overlapping_areas():
		var hitbox: HitboxComponent = area as HitboxComponent
		if hitbox.health_component != null:
			hitbox.health_component.take_damage($AttackComponent.damage, "Poison")
			
