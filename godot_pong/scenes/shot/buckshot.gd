extends Area2D

const SPEED = 1200
const SpeedIncrementByShot = 100

@export var max_distance := 250		# Distància màxima configurable

var velocity = Vector2.ZERO
var start_position: Vector2
var initialized = false

func _process(delta):
	if not initialized:
		velocity = Vector2(SPEED, 0).rotated(rotation)
		start_position = global_position
		initialized = true
		
	position += velocity * delta

	# Elimina si supera la distància màxima
	if global_position.distance_to(start_position) > max_distance:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("ball"):
		var vel = body.velocity

		# Apply a force to the ball
		if vel.x < 0:
			vel.x = abs(vel.x)
		else:
			vel.x += SpeedIncrementByShot
						
		body.velocity = vel

		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
