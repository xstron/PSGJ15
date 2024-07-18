extends CharacterBody2D

@export var speed: float = 50
@export var acceleration: float =  5



func _physics_process(delta: float):
	var direction: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
	
	velocity.x = move_toward(velocity.x, speed*direction.x, acceleration)
	velocity.y = move_toward(velocity.y, speed*direction.y, acceleration)

	move_and_slide()
