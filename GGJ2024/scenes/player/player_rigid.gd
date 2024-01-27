extends RigidBody2D

enum states {IDLE,MOVE,DASH,FALL,DEAD}

const force = 100
const dash_force = 2000

@export var gamepad = 0
@export var footstep_scene: PackedScene = null
@export var nb_dash = 5

@onready var timer_particle = $TimerParticle
@onready var timer_dash = $TimerDash

@onready var animated_sprite = $AnimatedSprite2D
@onready var footstep_pos = $AnimatedSprite2D/FootStepPosition
@onready var shadow = $Shadow

var step_active = false

var dash_count = 0
var dash_active = true

var state = null
var checkpoint_pos = Vector2(0,0)

var last_dash_force = Vector2.ZERO

var is_in_fall = false
var dead = false
var dashing = false

func _ready():
	dash_count = 0
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
			rotate_sprite(direction)
			if get_dash_input():
				dash(direction)
				change_player_scale()
			if abs(direction.length()) > 1.0:
				direction = direction.normalized()
				state = states.MOVE
		states.MOVE:
			if animated_sprite.animation != "run":
				animated_sprite.play("run")
			var direction = get_joystick_inputs()
			# Using the follow steering behavior.
			var target_force = direction * force
			apply_central_impulse(target_force)
			rotate_sprite(direction)
			handle_player_particles()
			if get_dash_input():
				if dash_active==true:
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
		states.DASH:
			rotate_sprite(last_dash_force)
			await get_tree().create_timer(0.15).timeout
			state = states.MOVE
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

func go_fall(pos):
	if state != states.DASH:
		move_to(pos)
		shadow.visible = false
		state = states.FALL
	
func dash(direction: Vector2):
	if dash_count<5:
		if timer_dash.time_left==0:
			timer_dash.start()
		dash_count += 1
		if direction.length() < 0.3:
			direction = Vector2(1,0).rotated(animated_sprite.global_rotation)
		last_dash_force = direction*dash_force 
		apply_central_impulse(last_dash_force)
		state = states.DASH
	else:
		dash_active=false
		timer_dash.start()
	
func update_checkpoint(pos: Vector2):
	checkpoint_pos = pos

func reset_to_checkpoint():
	is_in_fall = false
	freeze = false
	shadow.visible = true
	$AnimatedSprite2D.scale = Vector2.ONE
	$AnimatedSprite2D.rotation = -PI/2
	self.global_transform.origin = checkpoint_pos
	state = states.IDLE
	dead = false
	
func move_to(pos : Vector2):
	self.global_transform.origin = pos

func _on_timer_particle_timeout():
	step_active = false

func add_force(force: Vector2):
	if state in [states.IDLE,states.MOVE,states.DASH ]:
		apply_central_impulse(force)

func _on_hurtbox_body_entered(body):
	if body.is_in_group("player"):
		if body.state == states.DASH:
			add_force(body.last_dash_force.normalized()*dash_force)
			
func _on_timer_dash_timeout():
	dash_count = 0
	if dash_active==false:
		dash_active = true
