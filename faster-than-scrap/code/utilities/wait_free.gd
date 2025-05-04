class_name WaitFree

extends Node3D


func wait_free(wait: float) -> void:
	await get_tree().create_timer(wait).timeout
	queue_free()
