class_name DummyMissionSpawner

extends Node

@export var mission_to_spawn: MissionInfo


func _ready() -> void:
	mission_to_spawn.start(get_tree().current_scene)
