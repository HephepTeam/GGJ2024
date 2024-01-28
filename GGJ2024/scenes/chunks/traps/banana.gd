extends Area2D

@onready var glissade = $Glissade

const rebound_force = 3000

func _on_body_entered(body):
	if body.is_in_group("player"):
		$Sprite2D.scale = Vector2(randf_range(0.8, 1.2), randf_range(0.8, 1.2))
		var dir = body.get_joystick_inputs().rotated(randf_range(-PI/4,PI/4))
		body.add_force(dir * rebound_force)
		body.get_rotated(null)
		glissade.play()
		visible = false
		await glissade.finished
		queue_free()
