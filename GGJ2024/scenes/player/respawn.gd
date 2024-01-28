extends CPUParticles2D

func _ready():
	emitting = true
	await get_tree().create_timer(01.0).timeout
	queue_free()
