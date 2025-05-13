class_name WaitFree

extends Node3D

@export var wait: float = 1.0

func wait_free() -> void:
	await get_tree().create_timer(wait).timeout
	queue_free()
