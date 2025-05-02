@tool
class_name TimedParticle

extends Node3D

## Node that is removed from the scene after some time has passed.
## Primarily used for particles. It should a parent for them if there are multiple.
@export var _lifetime: float
## If parent of multiple particle systems, it allows previewing all of them at the same time.
@export var preview: bool = false


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	var timer := get_tree().create_timer(_lifetime)
	get_tree().create_timer(_lifetime).timeout.connect(_destroy_self)

	for child: GPUParticles3D in find_children("*", "GPUParticles3D"):
		child.emitting = true


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if preview:
			preview = false
			for child: GPUParticles3D in find_children("*", "GPUParticles3D"):
				child.restart()
		return


func _destroy_self():
	queue_free()
