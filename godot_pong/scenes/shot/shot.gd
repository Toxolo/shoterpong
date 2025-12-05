extends Area2D

const SPEED = 500
const SpeedIncrementByShot = 25
var velocity = Vector2.ZERO
var initialized = false

func _process(delta):
	if not initialized:
		velocity = Vector2(SPEED, 0).rotated(rotation)
		initialized = true
	position += velocity * delta

func _on_body_entered(body):
	if body.is_in_group("ball"):
		var vel = body.velocity

		# Apply a force to the ball
		# body.velocity += velocity.normalized() * SPEED
		if vel.x < 0:
			vel.x = abs(vel.x)
		else:
			vel.x += SpeedIncrementByShot
						
		body.velocity = vel

		# Destroy the shot
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
