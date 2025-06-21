extends Control

var scene_loader: SceneLoader
var brakes: CheckBox
var air_resistance: CheckBox
var cutscenes: CheckBox


func _enter_tree() -> void:
	scene_loader = $SceneLoader
	brakes = $Buttons/BrakesCheckBox
	air_resistance = $Buttons/AirResistanceCheckBox
	cutscenes = $Buttons/SkipCutscenesCheckBox
	brakes.button_pressed = SettingsManager.brakes_enabled
	air_resistance.button_pressed = SettingsManager.air_resistance
	cutscenes.button_pressed = SettingsManager.skip_cutscenes


func _on_button_pressed() -> void:
	scene_loader.load_main_menu_scene()


func _on_brakes_check_box_pressed() -> void:
	SettingsManager.brakes_enabled = brakes.is_pressed()


func _on_air_resistance_check_box_pressed() -> void:
	SettingsManager.air_resistance = air_resistance.is_pressed()


func _on_skip_cutscenes_check_box_pressed() -> void:
	SettingsManager.skip_cutscenes = cutscenes.is_pressed()
