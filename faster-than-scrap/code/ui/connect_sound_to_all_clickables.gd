extends Node

## A helper script that connects "button_down" signal to GlobalSoundManager.play_click_sound()
## method in the parent node and all of its children (if they have this signal)


func _ready() -> void:
	_connect_children(get_parent())


func _connect_children(node: Node) -> void:
	for child in node.get_children():
		if (
			child.has_signal("button_down")
			and not child.button_down.is_connected(GlobalSoundManager.play_click_sound)
		):
			child.button_down.connect(GlobalSoundManager.play_click_sound)
		_connect_children(child)
