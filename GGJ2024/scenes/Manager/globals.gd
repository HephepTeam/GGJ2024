extends Node

signal validate

var players = []
var cam = null
var game = null
var can_move = false
var player_number = 0

@export var trap_list : Array[PackedScene]

var current_game_points = [0,0,0,0]

var colors = [Color.AQUA, Color.BLUE_VIOLET, Color.CORNSILK, Color.CORAL]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("validate"):
		validate.emit()

func add_cam_target(t):
	if cam != null:
		cam.add_target(t)
		
func restart_game(nb):
	#player nb got 1 points
	current_game_points[nb] +=1
	await validate
	game.new_game()


func get_random_trap():
	trap_list.shuffle()
	return trap_list.front()
