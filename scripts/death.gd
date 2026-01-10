extends Area2D

@onready var timer = $Timer
var died = false

func _on_body_entered(body):
	if died == true:
		return
	died = true
	print("you died lol")
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
