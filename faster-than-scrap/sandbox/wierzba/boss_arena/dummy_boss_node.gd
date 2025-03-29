extends Node

@export var boss_prefab: PackedScene


func _enter_tree() -> void:
	BossManager.bosses_to_spawn = [boss_prefab]
