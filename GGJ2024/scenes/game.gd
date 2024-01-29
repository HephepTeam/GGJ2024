extends Node2D

const chunk_path = "res://scenes/chunks/chunks_pieces/"
var skin_nb_array = [0,1,2,3]

@onready var player_scene = preload("res://scenes/player/player_rigid.tscn")
@export var level_length : int = 4
@onready var pos = $Start_chunk.exits[0].global_position
@export var player_nb = 0

var pieces_scenes_path = []
var selected_pieces = []




func _ready():
	#start du compte à rebours
	Globals.start_music()
	Globals.game = self
	player_nb = Globals.player_number
	var colors = Globals.colors.duplicate()
	var temp_chunk_list = Globals.chunk_list.duplicate()
	for i in range(level_length):
		temp_chunk_list.shuffle()
		selected_pieces.append(temp_chunk_list.pop_front())
		
	#instanciation des chunks
	for pieces in selected_pieces:
		var inst = pieces.instantiate()
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
		if (pl == 0):
			if Globals.player_0_kb == true:
				inst.keyboard = true
		elif (pl == 1):
			if Globals.player_1_kb == true:
				inst.keyboard = true
		
		inst.position = start_pos[pl].position 
		skin_nb_array.shuffle()
		inst.skin_nb = skin_nb_array.pop_front()
		Globals.playertranslation_table[pl] = inst.skin_nb
		$CanvasLayer/Control.get_children()[pl].set_p_nb(pl)
		$CanvasLayer/Control.get_children()[pl].visible = true
		#inst.modulate = colors.pop_front()
		inst.rotation_degrees = -90
		add_child(inst)
		

func _on_run_ended(nb):
	$CanvasLayer/Winner.go(nb)
	$CanvasLayer/confettis.emitting = true

func new_game():
	SceneChanger.change_scene_by_name("game")	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
