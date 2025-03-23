class_name MapManager

extends Node

@export var map_container: Control
@export var button: Button
@export var label: Label
@export var scene_loader: SceneLoader

const default_map_select = preload("res://Sandbox/Wierzba/map_selector/map_example.tscn")


func _ready() -> void:
	print(MapSaver.map_select)
	if MapSaver.map_select == null:
		MapSaver.map_select = default_map_select.instantiate()
	var map := MapSaver.map_select
	map_container.add_child(map)

	button.pressed.connect(map.on_leave_button_clicked)
	map.label = label
	map.scene_loader = scene_loader

	map.update_self()
