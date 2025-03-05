class_name CopyPosition

extends Node3D

@export var from:Node3D
@export var offset:Vector3

func _process(delta: float) -> void:
	global_position = from.global_position + offset
