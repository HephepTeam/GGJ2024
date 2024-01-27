extends Area2D

const rebound_force = 3500
var enabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.scale = lerp($Sprite2D.scale, Vector2.ONE,0.3)


func _on_body_entered(body):
	if body.is_in_group("player"):
		$Sprite2D.scale = Vector2(randf_range(0.8, 1.2), randf_range(0.8, 1.2))
		var dir = (position+Vector2(128,128)).direction_to(body.position)
		body.add_force(dir * rebound_force)
		enabled = false
		await get_tree().create_timer(1.0).timeout
		enabled = true