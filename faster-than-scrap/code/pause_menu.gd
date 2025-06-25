extends Control

@onready var scene_loader: SceneLoader = $SceneLoader


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("pause_menu"):
		if not GameManager.game_over:
			change_menu()


func _on_resume_pressed() -> void:
	change_menu()


func _on_exit_pressed() -> void:
	change_menu()
	scene_loader.load_main_menu_scene()


func _on_settings_button_pressed() -> void:
	$Settings.visible = true


func change_menu() -> void:
	if visible:
		visible = false
		GameManager._unpause_entities()
	else:
		if GameManager.game_state != GameState.State.MAIN_MENU:
			visible = true
			$ColorRect/VBoxContainer/Resume.grab_focus()
			GameManager._pause_entities()
