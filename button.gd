extends Button

func _ready():
	pressed.connect(_on_button_press)
	
	
func _on_button_press():
	get_tree().change_scene_to_file("res://spacheship.tscn")
