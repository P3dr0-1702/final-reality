extends CharacterBody2D

@onready var timer: Timer = $Timer
@onready var bullet = preload("res://scenes/Bullet.tscn")

const SPEED = 200.0
@export var ACCEL: float = 600.0
@onready var player: CharacterBody2D = $"../player"
var flag = 0

func _physics_process(delta: float) -> void:
	look_at(player.global_position)
	var to_player := player.global_position - global_position
	var desired := to_player.normalized() * SPEED
	velocity = velocity.move_toward(desired, ACCEL * delta)
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	timer.start()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	timer.stop()

func _on_timer_timeout() -> void:
	var bullet_spawn = bullet.instantiate()
	bullet_spawn.collision_layer = 2
	bullet_spawn.collision_mask = 2
	get_tree().current_scene.add_child(bullet_spawn)
	bullet_spawn.rotation = rotation
	if flag == 1:
		bullet_spawn.global_position = $left.global_position
		flag = 0
	else:
		bullet_spawn.global_position = $right.global_position
		flag = 1
	var direction = Vector2.RIGHT.rotated(rotation).normalized()
	var ship_velocity = velocity
	bullet_spawn.initialize(direction, ship_velocity * 2)


func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
