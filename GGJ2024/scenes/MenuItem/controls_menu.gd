extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("start_game"):
		SceneChanger.change_scene_by_name("game")
