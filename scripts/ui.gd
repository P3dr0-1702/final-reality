extends Control

@onready var player: CharacterBody2D = $"../player"
@onready var label: Label = $CanvasLayer/Label
@onready var space: Node2D = $".."

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	label.text = "Velocity " + str(floor(player.velocity.length())) + "\n" + "Level: " + str(space.level)
