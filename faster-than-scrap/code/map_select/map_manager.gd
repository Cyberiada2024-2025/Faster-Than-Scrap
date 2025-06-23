class_name MapManager

extends Node

const DEFAULT_MAP_SELECT = preload("res://prefabs/map_select/full_maps/map1.tscn")

@export var map_container: Control
@export var button: Button
@export var label: RichTextLabel
@export var scene_loader: SceneLoader


func _ready() -> void:
	if MapSaver.map_select == null:
		MapSaver.map_select = DEFAULT_MAP_SELECT.instantiate()
	var map := MapSaver.map_select
	map_container.add_child(map)

	button.pressed.connect(map.on_leave_button_clicked)
	map.label = label
	map.scene_loader = scene_loader
	map.on_node_selected.connect(on_node_selected)
	map.update_self()


func on_node_selected(invalid: bool) -> void:
	button.disabled = invalid
