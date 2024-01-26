extends RigidBody2D

const force = 100

@export var gamepad = 0

func _physics_process(delta):
	var direction = Vector2(
		Input.get_joy_axis(gamepad,JOY_AXIS_LEFT_X),
		Input.get_joy_axis(gamepad,JOY_AXIS_LEFT_Y)
	)
	
	if direction.length() > 1.0:
		direction = direction.normalized()
		
	# Using the follow steering behavior.
	var target_force = direction * force
	apply_central_impulse(target_force)
	
