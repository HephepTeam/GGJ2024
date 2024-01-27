extends RigidBody2D

enum states {IDLE,MOVE,DASH,DEAD}

const force = 100

@export var gamepad = 0

@onready var animated_sprite = $AnimatedSprite2D

var state = null

func _ready():
	state = states.IDLE

func _physics_process(delta):
	var direction = Vector2(
		Input.get_joy_axis(gamepad,JOY_AXIS_LEFT_X),
		Input.get_joy_axis(gamepad,JOY_AXIS_LEFT_Y)
	)
	
	animated_sprite.global_rotation = lerp(animated_sprite.global_rotation,direction.angle(),0.5)
	
	match state:
		states.IDLE:
			animated_sprite.play("idle")
			if abs(direction.length()) > 1.0:
				direction = direction.normalized()
				state = states.MOVE
		states.MOVE:
			animated_sprite.play("run")
			# Using the follow steering behavior.
			var target_force = direction * force
			apply_central_impulse(target_force)
			if abs(direction.length()) < 0.3:
				state = states.IDLE
		states.DASH:
			print("DASH")
		states.DEAD:
			print("DEAD")
	
