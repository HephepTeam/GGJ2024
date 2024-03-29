extends TileMap

signal run_ended(nb)

@export var with_item = true

const bumper_scene = preload("res://scenes/chunks/traps/bumper.tscn")
const hole_scene = preload("res://scenes/chunks/traps/hole.tscn")
const trap_offset = Vector2(128,128)
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
	var cells = get_used_cells_by_id(1,2)
	for cell_coord in cells:
		erase_cell(1,cell_coord)
		var coord = map_to_local(cell_coord)
		var bumper = bumper_scene.instantiate()
		bumper.position = coord
		add_child(bumper)
		
	cells = get_used_cells_by_id(1,1)
	for cell_coord in cells:
		erase_cell(1,cell_coord)
		var coord = map_to_local(cell_coord)
		var hole = hole_scene.instantiate()
		hole.position = coord+Vector2(-128, -128)
		add_child(hole)
		
	if with_item:
		cells = get_used_cells_by_id(0,5, Vector2i(1,1))
		#cells.append(get_used_cells_by_id(0,3))
		
		cells.shuffle()
		for i in range(randi_range(3,6)):
			var cell_coord = cells.pop_front()
			var coord = map_to_local(cell_coord)
			var trap = Globals.get_random_trap().instantiate()
			trap.position = coord+Vector2(-128, -128)
			add_child(trap)
	

func _on_checkpoint_body_entered(body):
	if body.is_in_group("player"):
		body.update_checkpoint($checkpoint.global_position)


func _on_finish_line_body_entered(body):
	if body.is_in_group("player"):
		$FinishLine.monitoring = false
		$FinishLine.monitorable = false
		Globals.can_move = false
		run_ended.emit(body.gamepad)
