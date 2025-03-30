extends Node3D

var time: float = 0
@export var mission: Mission


func _process(delta: float) -> void:
	if time >= 0:
		time += delta
	if time >= 1:
		time = -1
		mission.finished.emit(mission)
