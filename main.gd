extends Node2D

@onready var window : Window = get_window()
@onready var viewport : Viewport = get_viewport()

func _ready() -> void:
	var real_window_size = window.size
	var game_window_size = viewport.get_visible_rect().size
	var scale = min(real_window_size.x / game_window_size.x, real_window_size.y / game_window_size.y)
	window.content_scale_size = Vector2i(game_window_size.x * scale, game_window_size.y * scale)
