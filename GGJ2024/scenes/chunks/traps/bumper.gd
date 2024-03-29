extends Area2D

const rebound_force = 3500
var enabled = true

@onready var bounce_particles = $BounceParticles

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.scale = lerp($Sprite2D.scale, Vector2.ONE,0.3)


func _on_body_entered(body):
	if body.is_in_group("player"):
		$prout.play_random()
		$Sprite2D.scale = Vector2(randf_range(0.8, 1.2), randf_range(0.8, 1.2))
		var dir = global_position.direction_to(body.global_position)
		body.add_force(dir * rebound_force)
		enabled = false
		bounce_particles.global_position = body.global_position
		bounce_particles.rotation = dir.angle()
		bounce_particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		enabled = true
