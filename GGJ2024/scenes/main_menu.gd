extends Control

@onready var player_notif_scene = preload("res://scenes/MenuItem/player_notif.tscn")

@onready var possible_pos = $possiblePos.get_children()

var nb_player = 0
var number_gamepad = [null, null, null, null]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func count_player():
	var i = 0
	for gp in number_gamepad:
		if gp != null:
			i+=1
	return i

func _input(event):
	if event is InputEventJoypadButton and event.is_pressed():
		print(event.device)
		if event.is_action("validate"):
			append_player(event.device, false)
		elif event.is_action("back"):
			remove_player(event.device)
		elif event.is_action("start_game"):
			start_game()
	elif event is InputEventKey and event.is_pressed():
		if event.is_action_pressed("dash0"):
			append_player(0,true)
		elif event.is_action_pressed("dash1"):
			append_player(1,true)
		elif event.is_action_pressed("keyboard_back"):
			remove_player(0)
			remove_player(1)
		elif event.is_action("start_game"):
			start_game()
			
func start_game():
	if nb_player >= 2:
		Globals.player_number = nb_player
		SceneChanger.change_scene_by_name("controls")
	else:
		$reuh.play()
		
func append_player(idx, keyboard):
	if number_gamepad[idx] == null:
		var inst = player_notif_scene.instantiate()
		inst.playernumber = idx
		if idx == 0:
			Globals.player_0_kb = keyboard
		elif idx == 1:
			Globals.player_1_kb = keyboard
		inst.position = possible_pos[idx].position
		number_gamepad[idx] = inst
		add_child(inst)
		
func remove_player(idx):
	if number_gamepad[idx] != null:
		number_gamepad[idx].kill()
		number_gamepad[idx] = null
		if idx == 0:
			Globals.player_0_kb = false
		elif idx == 1:
			Globals.player_1_kb = false
	

func _process(delta):
	nb_player = count_player()
	
		
