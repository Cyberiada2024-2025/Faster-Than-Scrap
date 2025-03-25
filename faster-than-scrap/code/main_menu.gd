extends Control

var scene_loader: SceneLoader


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Buttons/StartButton.grab_focus()
	scene_loader = $SceneLoader


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	# TODO change to main scene
	scene_loader.load_build_ship_scene()
