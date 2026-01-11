extends Node2D

@onready var bullet = preload("res://scenes/Bullet.tscn")
@export var asteroid_scene: PackedScene = preload("res://scenes/asteroid.tscn")
@export var enemy_scene = preload("res://scenes/enemy.tscn")
@export var spawn_max_radius : float = 1000
@export var player: Node2D
@export var target_radius: float = 200
@export var spawn_min_radius: float = 700
@export var speed_multiplier: int = 250
@export var speed_range: int = 100
@export var asteroids = []
@export var enemies = []
@export var target_asteroids_near_player: int = 100
@export var despawn_distance: float = 1000
@export var spawn_cooldown = 0.15
@export var enemy_cooldown = 5
@export var hj_drive: float = 0.0
@export var hj_goal: float = 100.0
@export var hj_th: float = 100.0
@export var hj_gain: float = 50.0
@export var hj_loss: float = 15.0
@export var level: int = 0
@onready var char: CharacterBody2D = $player
var _spawn_timer : float = 0.0
var _enemy_timer : float = 0.0
var player_speed: int = 0

func spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()

	# 1. Spawn point on outer ring
	var spawn_angle = randf() * PI * 2
	var spawn_distance = randf() * (spawn_max_radius - spawn_min_radius) + spawn_min_radius
	var spawn_pos = player.global_position + Vector2(cos(spawn_angle), sin(spawn_angle)) * spawn_distance

	# 2. Target point on inner ring (around player)
	var target_angle = randf() * PI * 2
	var target_pos = player.global_position + Vector2(cos(target_angle), sin(target_angle)) * target_radius

	# 3. Direction from spawn → target
	var direction = (target_pos - spawn_pos).normalized()

	# 4. Speed
	var speed_magnitude = randf() * speed_multiplier + speed_range
	var velocity = direction * speed_magnitude

	# 5. Type
	var asteroid_type = randi() % 12

	add_child(asteroid)
	asteroid.setup(asteroid_type, spawn_pos, velocity)
	asteroids.append(asteroid)

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	var spawn_distance = randf() * (spawn_max_radius - spawn_min_radius) + spawn_min_radius
	var spawn_angle = randf() * PI * 2
	var spawn_pos = player.global_position + Vector2(cos(spawn_angle), sin(spawn_angle)) * spawn_distance
	add_child(enemy)
	enemy.spawn(spawn_pos)
	enemies.append(enemy)

func _process(delta: float) -> void:
	update_hj_drive(delta)
	for asteroid in asteroids.duplicate():
		if not is_instance_valid(asteroid):
			asteroids.erase(asteroid)
			continue
		if asteroid.global_position.distance_to(player.global_position) > despawn_distance:
			asteroids.erase(asteroid)
			asteroid.queue_free()
	for enemy in enemies.duplicate():
		if not is_instance_valid(enemy):
			enemies.erase(enemy)
			continue
		if enemy.global_position.distance_to(player.global_position) > despawn_distance:
			enemies.erase(enemy)
			enemy.queue_free()
	_spawn_timer -= delta
	if _spawn_timer <= 0.0  and asteroids.size() < target_asteroids_near_player:
		spawn_asteroid()
		_spawn_timer = spawn_cooldown
	_enemy_timer -= delta
	
	if _enemy_timer <= 0.0:
		spawn_enemy()
		_enemy_timer = enemy_cooldown

func level_up():
	level += 1
	hj_drive = 0.0
	target_asteroids_near_player += 25
	speed_multiplier += 50
	hj_goal += 20
	hj_gain += 2

func update_hj_drive(delta: float) -> void:
	var player_velo = char.velocity.length()
	if char.death.died:
		return
	if player_velo >= hj_th:
		hj_drive += hj_gain * delta
	else:
		hj_drive -= hj_loss * delta
	hj_drive = clamp(hj_drive, 0.0, hj_goal)
	if hj_drive >= hj_goal:
		level_up()

func reset_game():
	player.global_position = Vector2(0,0)
	player.velocity.x = 0.0
	player.velocity.y = 0.0
	for asteroid in asteroids.duplicate():
		asteroid.queue_free()
	for enemy in enemies.duplicate():
		enemy.queue_free()
	level = 0
	hj_drive = 0
	hj_goal = 100.0
	char.death.died = false
	$player/AnimatedSprite2D.play("Default")
