extends CharacterBody2D
@onready var space: Node2D = $".."

var recoil_strength = 75
var flag = 1
@onready var scene = preload("res://scenes/Bullet.tscn")
@onready var asteroid = preload("res://scenes/asteroid.tscn")
@onready var death: Area2D = $death


func _physics_process(delta: float) -> void:
	if death.died:
		return
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	rotation += deg_to_rad(90)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if death.died:
		return
	if Input.is_action_just_pressed("fire"):
		shoot()
	if Input.is_action_just_pressed("shoot"):
		fire()
	if Input.is_action_just_pressed("restart"):
		space.reset_game()


func shoot():
	var recoil_dir = Vector2.UP.rotated(rotation)
	velocity += recoil_dir * recoil_strength

func fire():
	var bullet_spawn = scene.instantiate()
	bullet_spawn.collision_layer = 2 
	bullet_spawn.collision_mask = 2
	bullet_spawn.add_to_group("player_bullet")
	get_tree().current_scene.add_child(bullet_spawn)  
	#add_child(bullet_spawn)
	bullet_spawn.rotation = rotation
	if flag == 1:
		bullet_spawn.global_position = $l_wing.global_position
		flag = 0
	else:
		bullet_spawn.global_position = $r_wing.global_position
		flag = 1
	
	var direction = Vector2.UP.rotated(rotation).normalized()
	var ship_velocity = velocity
	bullet_spawn.initialize(direction, ship_velocity * 2)
