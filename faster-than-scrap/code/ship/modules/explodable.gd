class_name ExplodableModule

extends Module


## it destroys all direct children modules


## Destroy self and detach children
func _on_destroy() -> void:
	_explode()
	for child in self.get_children():
		# second check is needed for weak points as
		# they may have been already detached
		if child is Module and child.get_parent() == self:
			remove_child(child)  # detach from node tree
			get_tree().get_root().add_child(child)  # attach to scene root
			child._on_destroy()
	queue_free()  # delete self as an object
