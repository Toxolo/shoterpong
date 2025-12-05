extends Control

const BERETTA_SCENE = "res://scenes/guns/beretta/beretta.tscn"
const SHOTGUN_SCENE = "res://scenes/guns/shotgun/shotgun.tscn"
const AK47_SCENE = "res://scenes/guns/ak47/ak47.tscn"
const MAIN_GAME_SCENE = "res://scenes/pong/pong.tscn"

func _on_beretta_button_pressed():
	Global.selected_weapon_path = BERETTA_SCENE
	get_tree().change_scene_to_file(MAIN_GAME_SCENE)

func _on_shotgun_button_pressed():
	Global.selected_weapon_path = SHOTGUN_SCENE
	get_tree().change_scene_to_file(MAIN_GAME_SCENE)

func _on_ak_47_button_pressed() -> void:
	Global.selected_weapon_path = AK47_SCENE
	get_tree().change_scene_to_file(MAIN_GAME_SCENE)
