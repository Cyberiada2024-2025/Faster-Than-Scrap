class_name ExplodableModule

extends Module

## it destroys all direct children modules when it is destroyed


## Destroy self and detach children
func _on_destroy() -> void:
	_explode()
	var scene_root = get_tree().current_scene
	for child in child_modules:
		# second check is needed for weak points as
		# they may have been already detached
		if is_instance_valid(child) and child.get_parent() != scene_root:
			child.reparent(scene_root)
			child._on_destroy()
	queue_free()  # delete self as an object
