extends CanvasLayer

# Declare member variables here. Examples:
signal scene_changed(name)

@onready var animation_player = $AnimationPlayer

@export_file var game_path = ""
@export_file var controls_path = ""
@export_file var bilan_path = ""


var registered_scene = {}

var next_scene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	register_scene("game",game_path,"fade")
	register_scene("controls",controls_path,"fade")
	register_scene("bilan",bilan_path,"fade")
	
	

	
func register_scene(name, path, transition):
	registered_scene[name] = [path,transition]


func change_scene_by_name(name, delay=0.2):
	var transition
	if registered_scene.has(name):
		var new_scene_path = registered_scene[name][0]
		transition = registered_scene[name][1]
		change_scene(new_scene_path,transition,delay)
	#unknown name, crash or load error scene 
	
	
func change_scene(path,transition,delay=0.2):
	if(animation_player.is_playing()):
		await animation_player.animation_finished
	await get_tree().create_timer(delay).timeout
	
	#transition to hide the scene
	$Control.visible = true
	hide_scene(transition)
	await animation_player.animation_finished

	#load new scene and kill the previous one
	var current_scene = get_tree().get_current_scene()
	var s = ResourceLoader.load(path)
	var sc = s.instantiate()
	get_tree().get_root().add_child(sc)
	get_tree().set_current_scene(sc) 
	current_scene.queue_free()
	
	#wait a bit and transition to show the scene
	await get_tree().create_timer(0.05).timeout
	reveal_scene(transition)
	await animation_player.animation_finished
	
	$Control.visible = false
	emit_signal("scene_changed", path)

func hide_scene(transition):
	animation_player.play(transition)
	
func reveal_scene(transition):
	animation_player.play_backwards(transition)
		
func test_transition():
	hide_scene("arrow")
	await $Control/Sprite.animation_finished
	reveal_scene("arrow")

