extends Node3D

@export var mission: Mission
var time: float = 0


func _process(delta: float) -> void:
	if time >= 0:
		time += delta
	if time >= 1:
		time = -1
		mission.finished.emit(mission)
