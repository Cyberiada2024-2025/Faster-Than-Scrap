extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Buttons/StartButton.grab_focus()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	# TODO change to main scene
	# get_tree().change_scene_to_file("res://scenes/main_scene")
	pass
