class_name TimedGPUParticles3D

extends GPUParticles3D

## GPU particles that are removed from the scene after some time passes

@export var _lifetime: float

func _ready() -> void:
	await get_tree().create_timer(_lifetime).timeout
	queue_free()
