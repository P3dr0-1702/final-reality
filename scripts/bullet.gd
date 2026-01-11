extends RigidBody2D
var speed = 300

func initialize(direction: Vector2, ship_velocity: Vector2):
	var ship_speed = ship_velocity.length()
	var	total_speed = speed +    ship_speed
	linear_velocity = direction.normalized() * total_speed
	print("Bullet_speed ", round(total_speed))
	print(round(linear_velocity.x), " | ", round(linear_velocity.y))
