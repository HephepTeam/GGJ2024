extends Area2D

var enabled = true

func _on_body_entered(body):
	if body.is_in_group("player") and enabled:
		enabled = false
		body.get_stronger()
		visible = false
		$fete_snd.play()
		await $fete_snd.finished
		queue_free()
