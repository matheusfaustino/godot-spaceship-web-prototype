extends Area2D

var speed = 300  # Speed in pixels per second
var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")

func _process(delta):
	# Move downward
	position.y += speed * delta
	# Despawn when off-screen
	if position.y > screen_height + 50:  # Buffer for smooth despawn
		queue_free()
