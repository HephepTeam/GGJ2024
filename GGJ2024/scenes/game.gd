extends Node2D

const chunk_path = "res://scenes/chunks/chunks_pieces/"

@onready var player_scene = preload("res://scenes/player/player_rigid.tscn")

@export var level_length : int = 4

var pieces_scenes_path = []
var selected_pieces = []
var pos = Vector2(0,0)

@export var player_nb = 1

func _ready():
	var colors = Globals.colors.duplicate()
	#generation du level
	#lecture du disque 
	var dir = DirAccess.open(chunk_path)
	#listage des chunks
	pieces_scenes_path = Array(dir.get_files())
	#selection des chunks
	for i in range(4):
		pieces_scenes_path.shuffle()
		selected_pieces.append(pieces_scenes_path.front())
		
	#instanciation des chunks
	for pieces in selected_pieces:
		var inst = load(chunk_path+pieces).instantiate()
		inst.position = pos
		add_child(inst)
		pos = inst.exits[0].global_position
		
	#instanciate players
	var start_pos = $StartPositions.get_children()
	for pl in range(player_nb):
		var inst = player_scene.instantiate()
		inst.gamepad = pl
		inst.position = start_pos[pl].position 
		colors.shuffle()
		inst.modulate = colors.pop_front()
		add_child(inst)
		
	#start du compte à rebours
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
