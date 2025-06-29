extends Control

@export var tooltip_to_show: PackedScene


func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip = tooltip_to_show.instantiate()
	return tooltip
