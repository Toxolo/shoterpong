extends CharacterBody2D		# Script per controlar la pilota

var speed = 200                         # Velocitat base de la pilota
var min_x_speed = 200                   # Velocitat mínima absoluta en X després de rebots
var bounce_acceleration = 1.01          # Percentatge d'acceleració per rebot

func _ready():
	set_ball_velocity()
	
func set_ball_velocity():
	# Direcció inicial aleatòria en X
	if randi() % 2 == 0:
		velocity.x = 1
	else:
		velocity.x = -1

	# Direcció inicial aleatòria en Y
	if randi() % 2 == 0:
		velocity.y = 1
	else:
		velocity.y = -1

	# Normalitzem i apliquem la velocitat base
	velocity = velocity.normalized() * speed



func _physics_process(delta):
	if not self.visible:
		return

	var col = move_and_collide(velocity * delta)

	if col:
		# Rebota segons la normal de la col·lisió
		velocity = velocity.bounce(col.get_normal())

		# --- 1) Apliquem acceleració per rebot ---
		velocity *= bounce_acceleration

		# --- 2) Assegurem velocitat mínima en X ---
		if abs(velocity.x) < min_x_speed:
			velocity.x = min_x_speed * sign(velocity.x)
