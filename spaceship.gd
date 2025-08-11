extends Sprite2D

var speed = 400  # Movement speed in pixels per second
var target_position = position  # Target position for smooth movement
var is_mouse_held = false  # Track if left mouse button is held

func _input(event):
	# touch event
	if event is InputEventScreenTouch and event.pressed:
		target_position = event.position
	elif event is InputEventScreenDrag:
		target_position = event.position
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_mouse_held = true
			target_position = event.position
		else:
			is_mouse_held = false
	elif event is InputEventMouseMotion and is_mouse_held:
		target_position = event.position

func _process(delta):
	# Move toward the target position smoothly
	if position.distance_to(target_position) > 5:  # Small threshold to avoid jitter
		var direction = (target_position - position).normalized()
		position += direction * speed * delta
		position.x = clamp(position.x, 0, get_viewport_rect().size.x)
		position.y = clamp(position.y, 0, get_viewport_rect().size.y)
