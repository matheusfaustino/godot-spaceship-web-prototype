extends Node

@onready var window : Window = get_window()
@onready var viewport : Viewport = get_viewport()

func calculate_real_size() -> Vector2i:
	var real_window_size = window.size
	var game_window_size = viewport.get_visible_rect().size
	var scale = min(real_window_size.x / game_window_size.x, real_window_size.y / game_window_size.y)
	
	return Vector2i(game_window_size.x * scale, game_window_size.y * scale)
	
func apply_scale_to_window(new_scale: Vector2i) -> void:
	pass
	#window.content_scale_size = new_scale
