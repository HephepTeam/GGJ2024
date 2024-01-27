extends Control

signal animation_ended

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func go(nb):
	$Label.text ="Player "+str(nb+1) 
	var tw = get_tree().create_tween()
	tw.tween_property($TextureRect, "modulate:a", 1.0, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tw.parallel().tween_property($TextureRect, "scale", Vector2(1.0,1.0), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property($Label, "modulate:a", 1.0, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_callback(_on_tween_ended)

func _on_tween_ended():
	Globals.restart_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
