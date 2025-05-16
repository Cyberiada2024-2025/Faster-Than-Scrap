extends Node3D

## When this node is deleted, the new object will spawn and
## added to the root of the scene.

## Due to the lifecycle of a Node, the global position is saved each frame.
## When notification of deletion arrives, the node is already not in a scene tree, so
## the global_position is 0, thus the global_position needs saving.

@export var object_to_spawn: PackedScene

var last_global_pos: Vector3


func _process(_delta: float) -> void:
	last_global_pos = global_position


func _notification(notification: int) -> void:
	if notification == NOTIFICATION_PREDELETE:
		_drop()


func _drop() -> void:
	var object: Pickable = object_to_spawn.instantiate()

	GameManager.get_tree().current_scene.add_child.call_deferred(object)
	object.global_position = last_global_pos
