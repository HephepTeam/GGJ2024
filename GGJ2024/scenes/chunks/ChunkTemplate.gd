extends TileMap

const hole_scene = preload("res://scenes/chunks/traps/hole.tscn")

var exits = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	for child in children:
		if child is Marker2D:
			exits.append(child)
			
	place_traps()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func place_traps():
	#parse tilemap to place hole
	var cells = get_used_cells_by_id(0,2)
	for cell_coord in cells:
		var coord = map_to_local(cell_coord)
		var hole = hole_scene.instantiate()
		hole.position = coord+Vector2(-128, -128)
		add_child(hole)
		


func _on_checkpoint_body_entered(body):
	if body.is_in_group("player"):
		body.update_checkpoint($checkpoint.global_position)


func _on_finish_line_body_entered(body):
	if body.is_in_group("player"):
		print(body.gamepad)
