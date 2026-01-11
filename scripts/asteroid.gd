extends RigidBody2D

@export var speed: Vector2 = Vector2.ZERO
@onready var bullet = preload("res://scenes/Bullet.tscn")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collisions := [
	$Area2D/Asteroid1,
	$Area2D/Asteroid2,
	$Area2D/Asteroid3,
	$Area2D/Asteroid4,
	$Area2D/Asteroid5,
	$Area2D/Asteroid6,
	$Area2D/Asteroid7,
	$Area2D/Asteroid8,
	$Area2D/Asteroid9,
	$Area2D/Asteroid10,
	$Area2D/Asteroid11,
	$Area2D/Asteroid12
]

func destroy():
	queue_free()

func setup(asteroid_type: int, start_pos: Vector2, velocity: Vector2) -> void:
	position = start_pos
	speed = velocity
	
	asteroid_type = clamp(asteroid_type, 0, collisions.size() -1)
	sprite.play("Asteroid%d" % (asteroid_type + 1))
	for i in range(collisions.size()):
		collisions[i].disabled = i != asteroid_type

func _physics_process(delta: float) -> void:
	linear_velocity = speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	position += speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
