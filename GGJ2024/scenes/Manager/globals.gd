extends Node


var players = []
var cam = null

var colors = [Color.AQUA, Color.BLUE_VIOLET, Color.CORNSILK, Color.CORAL]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_cam_target(t):
	if cam != null:
		cam.add_target(t)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
