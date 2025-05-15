extends Node3D

## When this node is deleted, the new object will spawn and
## added to the root of the scene.

@export var object_to_spawn: PackedScene


func _notification(notification: int) -> void:
	if notification == NOTIFICATION_PREDELETE:
		var object: Node3D = object_to_spawn.instantiate()
		object.global_position = global_position

		GameManager.get_tree().current_scene.add_child.call_deferred(object)
