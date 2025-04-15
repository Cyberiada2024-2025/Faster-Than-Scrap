@tool
class_name TimedParticle

extends Node3D

## Node that is removed from the scene after some time has passed.
## Primarily used for particles.
@export var _lifetime: float

@export var preview: bool = false


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	var timer := get_tree().create_timer(_lifetime)
	get_tree().create_timer(_lifetime).timeout.connect(_destroy_self)

	for child: GPUParticles3D in find_children("*", "GPUParticles3D"):
		child.emitting = true


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if preview:
			preview = false
			for child: GPUParticles3D in find_children("*", "GPUParticles3D"):
				child.restart()
		return


func _destroy_self():
	queue_free()
