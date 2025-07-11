extends Control

var brakes_check_box: CheckBox
var air_resistance_check_box: CheckBox
var skip_cutscenes_check_box: CheckBox


func _enter_tree() -> void:
	brakes_check_box = $VBoxContainer/HBoxContainer/Buttons/BrakesCheckBox
	air_resistance_check_box = $VBoxContainer/HBoxContainer/Buttons/AirResistanceCheckBox
	skip_cutscenes_check_box = $VBoxContainer/HBoxContainer/Buttons/SkipCutscenesCheckBox

	brakes_check_box.button_pressed = SettingsManager.brakes_enabled
	air_resistance_check_box.button_pressed = SettingsManager.air_resistance
	skip_cutscenes_check_box.button_pressed = SettingsManager.skip_cutscenes


func _on_button_pressed() -> void:
	visible = false
	get_parent().focus()


func _on_brakes_check_box_pressed() -> void:
	SettingsManager.brakes_enabled = brakes_check_box.is_pressed()
	if GameManager.player_ship != null:
		GameManager.player_ship.change_cockpit_icon()


func _on_air_resistance_check_box_pressed() -> void:
	SettingsManager.air_resistance = air_resistance_check_box.is_pressed()
	if GameManager.player_ship != null:
		GameManager.player_ship.change_air_resistance()


func _on_skip_cutscenes_check_box_pressed() -> void:
	SettingsManager.skip_cutscenes = skip_cutscenes_check_box.is_pressed()


func _on_visibility_changed() -> void:
	if brakes_check_box != null:
		brakes_check_box.grab_focus()
