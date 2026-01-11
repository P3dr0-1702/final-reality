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
@export var hj_drive: float = 0.0
@export var hj_goal: float = 100.0
@export var hj_th: float = 400.0
@export var hj_gain: float = 20.0
@export var hj_loss: float = 15.0
@export var level: int = 1

@onready var char: CharacterBody2D = $player


var _spawn_timer : float = 0.0
var player_speed: int = 0

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

func level_up():
	level += 1
	hj_drive = 0.0
	
	target_asteroids_near_player += 5
	speed_multiplier += 15
	hj_goal += 20
	hj_gain += 2
	print("Level Up!!!")

func update_hj_drive(delta: float) -> void:
	if not player.has_method("linear_velocity"):
		return
	var player_velo = char.velocity.length()
	if player_velo >= hj_th:
		hj_drive += hj_gain * delta
	else:
		hj_drive -= hj_loss * delta
	hj_drive = clamp(hj_drive, 0.0, hj_goal)
	if hj_drive > hj_goal:
		level_up()
