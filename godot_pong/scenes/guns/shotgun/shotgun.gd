extends "res://scenes/guns/base/weapon.gd"

const BUCKSHOT_SCENE = preload("res://scenes/shot/buckshot.tscn")

# Shotgun-specific properties
const PELLET_COUNT = 7
const SPREAD_DEGREES = 22.0

func _ready():
	# --- Configure Base Weapon Stats ---
	fire_rate = 1.0 # shots per second
	magazine_size = 2
	reload_time = 2.5
	projectile_scene = BUCKSHOT_SCENE
	is_automatic = false  # true = dispara mantenint clicat
	
	# Call the parent _ready() function to set up timers and ammo
	super._ready()


# --- Override the _fire method for custom shotgun logic ---
func _fire(shot_origin_pos: Vector2, shot_origin_rot: float):
	if not projectile_scene:
		push_warning("Shotgun has no projectile_scene defined!")
		return

	var spread_radians = deg_to_rad(SPREAD_DEGREES)

	for i in range(PELLET_COUNT):
		var pellet = projectile_scene.instantiate()
		get_tree().root.add_child(pellet)
		
		pellet.global_position = shot_origin_pos
		
		# Add random spread
		var angle_offset = randf_range(-spread_radians / 2, spread_radians / 2)
		pellet.rotation = shot_origin_rot + angle_offset
