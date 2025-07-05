extends Node3D

## I have no idea why, but if I just place vortex in the scene, it doesn't show its graphics,
## it needs to be *spawned* for it to work

@export var start_scale: float = 400
@export var min_scale: float = 0.001
@export var shrinking_time: float = 180


func _ready() -> void:
	_spawn_vortex(global_position)


func _spawn_vortex(target_position: Vector3) -> void:
	SpaceVortex.spawn_vortex(target_position, start_scale, min_scale, shrinking_time)
