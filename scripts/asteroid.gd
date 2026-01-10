extends RigidBody2D

@export var speed: Vector2 = Vector2.ZERO

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collisions := [
	$Asteroid1,
	$Asteroid2,
	$Asteroid3,
	$Asteroid4,
	$Asteroid5,
	$Asteroid6,
	$Asteroid7
]

func setuo(asteroid_type: int, start_pos: Vector2, velocity: Vector2) -> void:
	position = start_pos
	speed = velocity
	
	asteroid_type = clamp(asteroid_type, 0, collisions.size() -1)
	sprite.play("Asteroid%d" % asteroid_type)
	for i in collisions.size():
		collisions[i].disabled = i != asteroid_type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += speed * delta
