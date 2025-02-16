extends Node

@export var mission_to_spawn: Mission

func _ready() -> void:
	mission_to_spawn.setup()
