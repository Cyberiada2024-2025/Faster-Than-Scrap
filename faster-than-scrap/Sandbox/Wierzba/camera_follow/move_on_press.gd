class_name MoveOnPress

extends Node3D

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_W):
		global_position += Vector3.FORWARD * delta
