extends VBoxContainer

var player_nb = 0
@export var textu : Array[Texture]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_p_nb(nb):
	player_nb = nb
	$TextureRect.texture = textu[Globals.playertranslation_table[nb]]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Score.text = str(Globals.current_game_points[player_nb])
