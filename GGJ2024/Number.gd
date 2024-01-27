extends Node2D

var count = 3
var to_kill =false

@export var textu: Array[Texture]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = textu[count]
	go()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func go():
	var tw = get_tree().create_tween()
	tw.tween_property($Sprite2D, "scale", Vector2(1.0,1.0), 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tw.parallel().tween_property($Sprite2D, "modulate:a", 0.0, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tw.tween_callback(_on_tween_ended)

func _on_tween_ended():
	if count > 0:
		count-=1
		$Sprite2D.texture = textu[count]
		$Sprite2D.modulate.a = 1.0
		$Sprite2D.scale = Vector2(0.01, 0.01)
		go()
	else:
		Globals.can_move = true
		queue_free()
