extends Node3D

@export var speed: float = 60

func _process(delta: float) -> void:
	rotate_z(speed * delta)
