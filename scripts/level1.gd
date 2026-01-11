extends Node2D

@export var asteroid_scene: PackedScene = preload("res://scenes/asteroid.tscn")
@export var spawn_max_radius : float = 1500
@export var player: Node2D
@export var spawn_min_radius: float = 1000
@export var speed_multiplier: int = 100
@export var speed_range: int = 50
@export var asteroids = []
@export var target_asteroids_near_player: int = 50
@export var despawn_distance: float = 2000
@export var spawn_cooldown = 0.15
var _spawn_timer : float = 0.0
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	for i in range(20):
#		spawn_asteroid()

func spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	var angle = randf() * PI * 2
	var s_angle = randf() * PI * 2
	var distance = randf() * (spawn_max_radius - spawn_min_radius) + spawn_min_radius
	var speed_magnitude = randf() * speed_multiplier + speed_range
	var velocity = Vector2(cos(s_angle), sin(s_angle)) * speed_magnitude
	var start_pos = player.global_position + Vector2(cos(angle), sin(angle)) * distance
	var asteroid_type = randi() % 12
	add_child(asteroid)
	asteroid.setup(asteroid_type, start_pos, velocity)
	asteroids.append(asteroid)

func _process(delta: float) -> void:
	for asteroid in asteroids.duplicate():
		if not is_instance_valid(asteroid):
			asteroids.erase(asteroid)
			continue
		if asteroid.global_position.distance_to(player.global_position) > despawn_distance:
			asteroids.erase(asteroid)
			asteroid.queue_free()
	_spawn_timer -= delta
	if _spawn_timer <= 0.0  and asteroids.size() < target_asteroids_near_player:
		spawn_asteroid()
		_spawn_timer = spawn_cooldown
	#while asteroids.size() < target_asteroids_near_player:
	#	spawn_asteroid()
