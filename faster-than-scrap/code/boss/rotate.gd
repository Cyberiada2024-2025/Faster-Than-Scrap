class_name Rotatable

extends Node3D

@export var speed:float

func _process(delta: float) -> void:
	rotate_y(speed*delta)
