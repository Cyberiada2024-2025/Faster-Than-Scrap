extends Control

var scene_loader: SceneLoader
var brakes: CheckBox


func _enter_tree() -> void:
	scene_loader = $SceneLoader
	brakes = $Buttons/BrakesCheckBox
	brakes.button_pressed = SettingsManager.brakes_enabled


func _on_button_pressed() -> void:
	scene_loader.load_main_menu_scene()


func _on_brakes_check_box_pressed() -> void:
	SettingsManager.brakes_enabled = brakes.is_pressed()


func _on_air_resistance_check_box_pressed() -> void:
	pass  # Replace with function body.
