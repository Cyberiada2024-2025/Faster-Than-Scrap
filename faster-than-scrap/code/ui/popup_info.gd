class_name PopupInfo
extends Control

static var popup_info_prefab: PackedScene = preload("res://prefabs/ui/popup/popup_info.tscn")


## virtual constructor of popup
static func _show_popup(title: String, content: String) -> void:
	var popup: Control = popup_info_prefab.instantiate()
	popup._setup(title, content)
	popup.process_mode = Node.PROCESS_MODE_ALWAYS

	# add to the scene
	GameManager.get_tree().current_scene.add_child(popup)
	# pause the game
	GameManager._pause_entities()

	# await confirm
	var confirm_button: Button = popup.get_node("PopupConfirmButton")
	await confirm_button.pressed

	# unpause the game
	GameManager._unpause_entities()
	popup.queue_free()


func _setup(title: String, content: String) -> void:
	# set title
	var title_label: Label = $HBoxContainer/VBoxContainer/Title
	title_label.text = title

	# set content
	var content_label: Label = $HBoxContainer/VBoxContainer/PopupContent/Label
	content_label.text = content
