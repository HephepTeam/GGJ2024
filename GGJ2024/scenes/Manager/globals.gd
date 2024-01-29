extends Node

signal validate

var players = []
var cam = null
var game = null
var can_move = false
var player_number = 0

var round_nb_max = 4
var round_nb = 0
var player_0_kb = false
var player_1_kb = false

@export var chunk_list : Array[PackedScene]
@export var trap_list : Array[PackedScene]


var playertranslation_table = [0,0,0,0]
var current_game_points = [0,0,0,0]

var colors = [Color.AQUA, Color.BLUE_VIOLET, Color.CORNSILK, Color.CORAL]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("validate"):
		validate.emit()

func start_music():
	if !$Music.playing:
		$Music.play()
		
func stop_music():
	$Music.stop()

func add_cam_target(t):
	if cam != null:
		cam.add_target(t)
		
func restart_game(nb):
	#player nb got 1 points
	current_game_points[nb] +=1
	await validate
	if round_nb < round_nb_max:
		round_nb+=1
		game.new_game()
	else:
		stop_music()
		SceneChanger.change_scene_by_name("bilan")

func get_highest_points_count():
	var max = 0
	for score in current_game_points:
		if score > max:
			max = score
	return max
func get_random_trap():
	trap_list.shuffle()
	return trap_list.front()
