extends "res://scenes/guns/base/weapon.gd"

const AK47_SCENE = preload("res://scenes/shot/fusils/ak47/ak47shot.tscn")

# ak47-specific properties
const PELLET_COUNT = 1
const SPREAD_DEGREES = 40.0
var last_shot_time := 0.0
var consecutive_shots := 0
const RESET_TIME := 0.5
const PRECISE_BULLETS := 2 


func _ready():
	# --- Configure Base Weapon Stats ---
	fire_rate = 10.0 # shots per second
	magazine_size = 30
	reload_time = 2.5
	projectile_scene = AK47_SCENE
	is_automatic = true
	
	# Call the parent _ready() function to set up timers and ammo
	super._ready()


# --- Override the _fire method for custom shotgun logic ---
func _fire(shot_origin_pos: Vector2, shot_origin_rot: float):
	if not projectile_scene:
		push_warning("Ak47 has no projectile_scene defined!")
		return
		
	var now = Time.get_ticks_msec() / 1000.0   # Temps en segons
	if now - last_shot_time > RESET_TIME:
		consecutive_shots = 0
		
	last_shot_time = now
	
	var is_precise_shot = consecutive_shots < PRECISE_BULLETS
	consecutive_shots += 1
	
	var spread_radians = deg_to_rad(SPREAD_DEGREES)

	for i in range(PELLET_COUNT):
		var pellet = projectile_scene.instantiate()
		get_tree().root.add_child(pellet)
		pellet.global_position = shot_origin_pos
		
		if is_precise_shot:
			pellet.rotation = shot_origin_rot
		else:
			var angle_offset = randf_range(-spread_radians / 2, spread_radians / 2)
			pellet.rotation = shot_origin_rot + angle_offset
