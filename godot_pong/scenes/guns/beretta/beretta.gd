extends "res://scenes/guns/base/weapon.gd"

const SHOT_SCENE = preload("res://scenes/shot/shot.tscn")

func _ready():
	# --- Configure Base Weapon Stats ---
	fire_rate = 5.0 # shots per second
	magazine_size = 12
	reload_time = 1.8
	projectile_scene = SHOT_SCENE
	is_automatic = false  # true = dispara mantenint clicat

	
	# Call the parent _ready() function to set up timers and ammo
	super._ready()

# The beretta fires a single projectile, so we can just use the
# default _fire() implementation from the base Weapon class.
# No need to override it.
