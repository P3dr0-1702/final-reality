extends RigidBody2D
@export var speed = 3000
@export var lifetime := 2.0

func initialize(direction: Vector2, ship_velocity: Vector2):
	var ship_speed = ship_velocity.length()
	var	total_speed = speed +    ship_speed
	linear_velocity = direction.normalized() * total_speed
	
func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
