extends CharacterBody2D

@onready var timer: Timer = $Timer
#@onready var bullet = preload("res://scenes/Bullet.tscn")

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	var direction := 0
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	timer.start()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	timer.stop()

func _on_timer_timeout() -> void:
	print("shoot")
	#var bullet_spawn = bullet.instantiate()
	#get_tree().current_scene.add_child(bullet_spawn)
