extends Node2D

@export var textu: Array[Texture]

var playernumber = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$gamepad.texture = textu[playernumber]
	$Label.text = "Player "+str(playernumber+1)
	$coin.play()
	var tween = get_tree().create_tween()
	tween.tween_property($gamepad, "scale", Vector2.ONE, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property($Label, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property($shadow, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func kill():
	$reuh.play()
	var tween = get_tree().create_tween()
	tween.tween_property($Label, "modulate:a", 0.0, 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property($shadow, "modulate:a", 0.0, 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property($gamepad, "scale", Vector2.ZERO, 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	await tween.finished
	queue_free()
