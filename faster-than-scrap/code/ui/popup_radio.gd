class_name PopupRadio
extends Control

## Popup with title, description and radio buttons. It can also return a result
## of a selection as index of an options passed as argument while creating the popup.
## To obtain the result 'await' call should be used.

static var popup_radio_prefab: PackedScene = preload("res://prefabs/ui/popup/popup_radio.tscn")
static var popup_radio_button_prefab: PackedScene = preload(
	"res://prefabs/ui/popup/popup_elements/popup_radio_button.tscn"
)

@export_color_no_alpha var selected_color: Color
@export_color_no_alpha var unselected_color: Color

var selection: int = 0
var buttons: Array[Button] = []


static func show_popup(title: String, content: String, options: Array[String]) -> int:
	var popup: Control = popup_radio_prefab.instantiate()
	popup._setup(title, content, options)
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
	return popup.selection


func _setup(title: String, content: String, options: Array[String]) -> void:
	# set title
	var title_label: Label = $HBoxContainer/VBoxContainer/Title
	title_label.text = title

	# set content
	var content_label: Label = $HBoxContainer/VBoxContainer/PopupContent/VBoxContainer/Label
	content_label.text = content

	# add button
	var buttons_container: Control = $%ButtonsContainer

	var index = 0
	for option: String in options:
		var button: Button = popup_radio_button_prefab.instantiate()
		buttons.append(button)
		button.pressed.connect(func(): on_radio_change(index))
		button.text = options[index]
		buttons_container.add_child(button)
		if index == 0:
			button.set_pressed_no_signal(true)
		index += 1


func on_radio_change(new_selection: int) -> void:
	buttons[selection].set_pressed_no_signal(false)
	selection = new_selection
