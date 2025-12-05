class_name Jugador
extends CharacterBody2D

var speed = 500

# --- Weapon Handling ---
var current_weapon: Weapon
@onready var weapon_mount = $WeaponMount

# --- Ready ---
func _ready():
	# If a weapon was selected from the menu, instantiate it
	if Global.selected_weapon_path and not Global.selected_weapon_path.is_empty():
		var weapon_scene = load(Global.selected_weapon_path)
		if weapon_scene:
			current_weapon = weapon_scene.instantiate()
			weapon_mount.add_child(current_weapon)
		else:
			push_error("Failed to load weapon scene from path: " + Global.selected_weapon_path)
	else:
		push_warning("No weapon path found in Global singleton. Player has no weapon.")


# --- Input Handling ---
func _unhandled_input(event):
	# Player cannot act if the ball is not in play
	if not get_parent().get_node("Ball").visible:
		return

	# Handle shooting
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if current_weapon:
			# The weapon itself now handles all logic (fire rate, ammo, etc.)
			# We just need to provide the position and rotation for the projectile
			current_weapon.shoot(weapon_mount.global_position, current_weapon.global_rotation)

	# Handle manual reload
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_R:
		if current_weapon:
			current_weapon.reload()


# --- Physics Process ---
func _physics_process(delta):
	# Player cannot move if the ball is not in play
	if not get_parent().get_node("Ball").visible:
		return

	velocity.y = 0
	if Input.is_key_pressed(KEY_W):
		velocity.y = -1
	elif Input.is_key_pressed(KEY_S):
		velocity.y = 1

	velocity.y *= speed
	move_and_collide(velocity * delta)
	
	# --- Disparo continuo ---
	if current_weapon and current_weapon.is_automatic:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			current_weapon.shoot(
				weapon_mount.global_position,
				current_weapon.global_rotation
			)
