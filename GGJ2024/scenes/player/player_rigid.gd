extends RigidBody2D

enum states {IDLE,MOVE,DASH,FALL,DEAD}

const force = 100
const dash_force = 2000

@export var gamepad = 0
@onready var animated_sprite = $AnimatedSprite2D

var state = null

var is_in_fall = false
var dashing = false

func _ready():
	Globals.players.append(self)
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
			if get_dash_input():
				dash(direction)
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
			
		states.DASH:
			await get_tree().create_timer(0.3).timeout
			state = states.IDLE
		states.DEAD:
			print("DEAD")


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
