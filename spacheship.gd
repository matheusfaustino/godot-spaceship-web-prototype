extends Node2D

var asteroid_scene = preload("res://asteroid.tscn")
var spawn_interval = 5.0  # Seconds between spawns
var spawn_timer = 0.0

func _process(delta):
	# Update spawn timer
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_asteroid()
		spawn_timer = 0.0

func spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	# Random x-position at the top of the screen
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	asteroid.position = Vector2(randf_range(0, screen_width), -50)  # Start above screen
	add_child(asteroid)
