class_name Weapon
extends Node2D

# Signal for UI updates
signal ammo_updated(current_ammo, magazine_size)

# --- Weapon Stats ---
# To be configured by inheriting weapons
@export var fire_rate: float = 0.5  # Shots per second
@export var magazine_size: int = 10
@export var reload_time: float = 1.5 # Seconds
@export var is_automatic = false  # true = dispara mantenint clicat


# --- Projectile ---
# To be set by inheriting weapons
@export var projectile_scene: PackedScene

# --- Internal State ---
var current_ammo: int
var is_reloading: bool = false
var can_shoot: bool = true

# --- Nodes ---
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var reload_timer: Timer = $ReloadTimer


func _ready():
	current_ammo = magazine_size
	fire_rate_timer.wait_time = 1.0 / fire_rate
	reload_timer.wait_time = reload_time
	# Connect signals
	fire_rate_timer.timeout.connect(_on_fire_rate_timer_timeout)
	reload_timer.timeout.connect(_on_reload_finished)


func _process(delta):
	look_at(get_global_mouse_position())


# --- Public API ---

# Called by the player
func shoot(shot_origin_pos: Vector2, shot_origin_rot: float):
	if not can_shoot or is_reloading or current_ammo == 0:
		return

	# If ammo is depleted, start a reload
	if current_ammo <= 0:
		reload()
		return

	_fire(shot_origin_pos, shot_origin_rot)
	
	current_ammo -= 1
	can_shoot = false
	fire_rate_timer.start()
	emit_signal("ammo_updated", current_ammo, magazine_size)

	# Auto-reload when empty
	if current_ammo <= 0:
		reload()


# Called by the player or automatically
func reload():
	if is_reloading or current_ammo == magazine_size:
		return # Can't reload if already reloading or if the magazine is full

	is_reloading = true
	reload_timer.start()
	print("Reloading...")


# --- Internal Logic ---

# This method should be overridden by specific weapons
func _fire(shot_origin_pos: Vector2, shot_origin_rot: float):
	# Default implementation: fire one projectile
	if projectile_scene:
		var projectile = projectile_scene.instantiate()
		get_tree().root.add_child(projectile)
		projectile.global_position = shot_origin_pos
		projectile.rotation = shot_origin_rot
	else:
		push_warning("Weapon has no projectile_scene defined!")

func _on_fire_rate_timer_timeout():
	can_shoot = true

func _on_reload_finished():
	is_reloading = false
	current_ammo = magazine_size
	can_shoot = true
	emit_signal("ammo_updated", current_ammo, magazine_size)
	print("Reloaded!")
