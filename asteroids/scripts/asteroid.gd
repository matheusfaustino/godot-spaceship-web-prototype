extends Area2D

var speed := 300  # Speed in pixels per second
var bonus_speed := 0
var MAX_BONUS_SPEED := 100

signal increase_speed(new_speed)

func _process(delta):
	# Move downward
	position.y += (speed + min(bonus_speed, MAX_BONUS_SPEED)) * delta

func _on_increase_speed(new_speed) -> void:
	bonus_speed = new_speed
