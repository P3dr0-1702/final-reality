extends CharacterBody2D
var recoil_strength = 100


func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	rotation += deg_to_rad(-90)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire"):
		shoot()

func shoot():
	print("FIRE!")
	var recoil_dir = -Vector2.DOWN.rotated(rotation)
	velocity += recoil_dir * recoil_strength
