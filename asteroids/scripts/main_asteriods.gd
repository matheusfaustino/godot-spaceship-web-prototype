extends Node2D

const ASTEROIDS_SCENE = preload("res://asteroids/scenes/asteroid.tscn")
const ASTEROIDS_SPEED: int = 500
const SCORE_MODIFIED: int = 10
const INITIAL_POSITION_SPACESHIP = Vector2i(979.0, 354.0)
const SPRITE_Y_POSITION_BUFFER: int = 10
const MAX_OBSTACLES_SPAWN: int = 5
const THRESHOLD_DIFFICULTY_BY_SCORE: int = 10

var highest_score: int = 0
var score: int = 0
var time_game_started: int = 0
var is_game_running: bool = false
var obstacles_types: Array[PackedScene] = [ASTEROIDS_SCENE]
var obstacles: Array[Area2D] = []
var screen_size: Vector2i

func _ready() -> void:
	var real_size = ScreenScale.calculate_real_size()
	ScreenScale.apply_scale_to_window(real_size)
	
	get_viewport().size = real_size
	screen_size = real_size
	print(screen_size)
	$GameOver.get_node('Button').pressed.connect(waiting_to_play)
	waiting_to_play()

func _input(event: InputEvent) -> void:
	if is_game_running:
		return
		
	var is_tap_event = event is InputEventScreenTouch and event.pressed
	var is_mouse_clicked = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT
	
	if is_tap_event or is_mouse_clicked:
		new_game()

func _process(_delta) -> void:
	if is_game_running == false:
		return
	
	spawn_asteroid()
	
	var new_score = calculate_score()
	update_score(new_score)
	
	increase_speed()
	
	clean_obstacles()

func calculate_score() -> int:
	return int((Time.get_unix_time_from_system() - time_game_started))

func spawn_asteroid() -> void:
	var can_spawn_another = obstacles.is_empty() or obstacles.back().position.y > randi_range(50, 2000)
	if can_spawn_another == false:
		return

	var player_position = $spaceship.position
	var min_obstacles_spawn = min(score / THRESHOLD_DIFFICULTY_BY_SCORE, MAX_OBSTACLES_SPAWN)
	for _i in randi_range(min_obstacles_spawn, MAX_OBSTACLES_SPAWN):
		var asteroid_types: PackedScene = obstacles_types.pick_random()
		var asteroid = asteroid_types.instantiate()
		
		var asteroid_height = asteroid.get_node('Sprite2D').texture.get_height()
		var asteroid_width = asteroid.get_node('Sprite2D').texture.get_width()
		
		var asteroid_y = randi_range(asteroid_height / 3, asteroid_height + 50)
		
		var asteroid_threshold = asteroid_width / 4
		var asteroid_x: int = 0
		if _i == 1:
			asteroid_x = randi_range(player_position.x - asteroid_threshold, player_position.x + asteroid_threshold)
		else:
			asteroid_x = randi_range(-asteroid_threshold, screen_size.x + asteroid_threshold)
		
		if obstacles.size() > 0:
			var previous_obs_x = obstacles.back().position.x
			var previous_obs_width = obstacles.back().get_node('Sprite2D').texture.get_width()
			if abs(asteroid_x - previous_obs_x) <= previous_obs_width:
				asteroid_x += [1, -1].pick_random() * previous_obs_width
				
		asteroid.position = Vector2i(asteroid_x, -asteroid_y)
		asteroid.body_entered.connect(detect_hit_asteroid)
		# add to the scene
		add_child(asteroid)
		obstacles.append(asteroid)

func clean_obstacles() -> void:
	for obs in obstacles:
		if obs == null:
			continue
			
		var threshold_obs = obs.get_node('Sprite2D').texture.get_height() / 2
		if (obs.position.y - threshold_obs) > screen_size.y:
			obstacles.erase(obs)
			obs.queue_free()


func force_clean_obstacles() -> void:
	for obs in obstacles:
		if obs == null:
			continue
		obs.queue_free()	
	obstacles = [];

func increase_speed() -> void:
	for obs in obstacles:
		obs.emit_signal('increase_speed', int(score / 5))

func detect_hit_asteroid(body) -> void:
	if body.name == "spaceship":
		game_over()

func update_score(new_score) -> void: 
	$Hud.get_node("ScoreLabel").text = "SCORE: " + str(new_score)
	score = new_score

func waiting_to_play() -> void:
	$spaceship.hide()
	$GameOver.hide()
	$Hud.get_node("TapToPlay").show()
	get_tree().paused = false
	reset()

func new_game() -> void:
	reset()
	is_game_running = true
	time_game_started = int(Time.get_unix_time_from_system())
	
	$spaceship.show()
	$Hud.get_node("TapToPlay").hide()
	$GameOver.hide()
	
func reset() -> void:
	is_game_running = false
	$spaceship.position = INITIAL_POSITION_SPACESHIP
	time_game_started = 0
	score = 0
	force_clean_obstacles()

func game_over() -> void:
	highest_score = max(score, highest_score)
	is_game_running = false
	get_tree().paused = true
	$GameOver.show()
	$Hud.get_node("HighestScoreLabel").text = "High Score: " + str(highest_score)
