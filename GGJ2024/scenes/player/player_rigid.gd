extends RigidBody2D

enum states {IDLE,MOVE,DASH,FALL,DEAD}

const force = 100
const dash_force = 2000

@export var gamepad = 0

#integration de l'effet foot step
@export var footstep_scene: PackedScene = null
@onready var timer_particle = $TimerParticle
var step_active = false

@onready var animated_sprite = $AnimatedSprite2D
@onready var footstep_pos = $AnimatedSprite2D/FootStepPosition
@onready var shadow = $Shadow

var state = null
var checkpoint_pos = Vector2(0,0)

var is_in_fall = false
var dead = false
var dashing = false

func _ready():
	Globals.add_cam_target(self)
	state = states.IDLE

func get_joystick_inputs():
	var direction = Vector2(
		Input.get_joy_axis(gamepad,JOY_AXIS_LEFT_X),
		Input.get_joy_axis(gamepad,JOY_AXIS_LEFT_Y)
	)
	return direction

func get_dash_input():
	return Input.is_action_just_pressed("dash"+str(gamepad))
	
func rotate_sprite(direction: Vector2):
	animated_sprite.global_rotation = lerp(animated_sprite.global_rotation,direction.angle(),0.5)

func _physics_process(delta):
	match state:
		states.IDLE:
			animated_sprite.play("idle")
			var direction = get_joystick_inputs()
			if get_dash_input():
				dash(direction)
			if abs(direction.length()) > 1.0:
				direction = direction.normalized()
				state = states.MOVE
		states.MOVE:
			animated_sprite.play("run")
			var direction = get_joystick_inputs()
			# Using the follow steering behavior.
			var target_force = direction * force
			apply_central_impulse(target_force)
			rotate_sprite(direction)
			handle_player_particles()
			if get_dash_input():
				dash(direction)
				change_player_scale()
			if abs(direction.length()) < 0.3:
				state = states.IDLE
		states.FALL:
			if !is_in_fall:
				is_in_fall = true
				freeze = true
				animated_sprite.play("fall"+str(randi_range(0,1)))
				var tween = get_tree().create_tween()
				tween.tween_property($AnimatedSprite2D, "scale", Vector2(0,0), 1.0).set_trans(Tween.TRANS_SINE)
				tween.parallel().tween_property($AnimatedSprite2D, "rotation", 2*PI, 1.0).set_trans(Tween.TRANS_SINE)
				await tween.finished
				state = states.DEAD
				print("dead")
		states.DASH:
			await get_tree().create_timer(0.3).timeout
			state = states.IDLE
		states.DEAD:
			if !dead:
				dead = true
				await get_tree().create_timer(0.5).timeout
				reset_to_checkpoint()

func handle_player_particles():
	if step_active==false:
		step_active=true
		timer_particle.start()
		var footstep_instance = footstep_scene.instantiate()
		footstep_instance.global_position = Vector2(footstep_pos.global_position)
		get_parent().add_child(footstep_instance)

func change_player_scale():
	var sprite_scale = animated_sprite.global_scale
	var shadow_scale = shadow.global_scale
	animated_sprite.global_scale = animated_sprite.global_scale.lerp(Vector2(1.6,0.4),1)
	shadow.global_scale = shadow.global_scale.lerp(Vector2(0.4,0.4),1)
	await get_tree().create_timer(0.1).timeout
	animated_sprite.global_scale = sprite_scale
	shadow.global_scale = shadow_scale

func go_fall():
	if state != states.DASH:
		state = states.FALL
	
func dash(direction: Vector2):
	print("dash")
	if direction.length() < 0.3:
		print("no direction")
		direction = Vector2(1,0).rotated(animated_sprite.global_rotation)
	apply_central_impulse(direction*dash_force)
	state = states.DASH
	
func update_checkpoint(pos: Vector2):
	checkpoint_pos = pos

func reset_to_checkpoint():
	print("Reset")
	is_in_fall = false
	freeze = false
	$AnimatedSprite2D.scale = Vector2.ONE
	$AnimatedSprite2D.rotation = -PI/2
	self.global_transform.origin = checkpoint_pos
	#position = checkpoint_pos
	state = states.IDLE
	dead = false

func _on_timer_particle_timeout():
	step_active = false

func _on_body_area_entered(area):
	if state == states.DASH:
		var direction = get_joystick_inputs()
		var target_force = direction * force
		area.get_parent().apply_central_impulse(-target_force)
