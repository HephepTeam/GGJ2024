extends Node2D

const chunk_path = "res://scenes/chunks/chunks_pieces/"

@onready var player_scene = preload("res://scenes/player/player_rigid.tscn")
@export var level_length : int = 4
@onready var pos = $Start_chunk.exits[0].global_position
@export var player_nb = 0

var pieces_scenes_path = []
var selected_pieces = []




func _ready():
	Globals.game = self
	player_nb = Globals.player_number
	var colors = Globals.colors.duplicate()
	#generation du level
	#lecture du disque 
	var dir = DirAccess.open(chunk_path)
	#listage des chunks
	pieces_scenes_path = Array(dir.get_files())
	#selection des chunks
	for i in range(level_length):
		pieces_scenes_path.shuffle()
		selected_pieces.append(pieces_scenes_path.front())
		
	#instanciation des chunks
	for pieces in selected_pieces:
		var inst = load(chunk_path+pieces).instantiate()
		inst.position = pos
		add_child(inst)
		pos.y = inst.exits[0].global_position.y
		
	var inst_end = load("res://scenes/chunks/end_chunk.tscn").instantiate()
	inst_end.position = pos
	inst_end.run_ended.connect(_on_run_ended)
	add_child(inst_end)
		
	#instanciate players
	var start_pos = $StartPositions.get_children()
	for pl in range(player_nb):
		var inst = player_scene.instantiate()
		inst.gamepad = pl
		inst.position = start_pos[pl].position 
		colors.shuffle()
		inst.modulate = colors.pop_front()
		inst.rotation_degrees = -90
		add_child(inst)
		
	#start du compte à rebours
	$Music.play()

func _on_run_ended(nb):
	$CanvasLayer/Winner.go(nb)

func new_game():
	get_tree().reload_current_scene()	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
