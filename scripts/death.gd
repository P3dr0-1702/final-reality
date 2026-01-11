extends Area2D

@export var died = false
@onready var timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"

func _on_body_entered(body):
	if died == true:
		return
	died = true
	animated_sprite_2d.play("Death")
	print("you died lol")
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()


func _on_area_entered(area: Area2D) -> void:
	if died == true:
		return
	died = true
	animated_sprite_2d.play("Death")
	print("you died lol")
	timer.start()
