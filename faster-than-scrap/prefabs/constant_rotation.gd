extends Node3D

@export var rot: Vector3 = Vector3(0, 0, 0)

func _process(_delta: float) -> void:
	global_rotation = rot
