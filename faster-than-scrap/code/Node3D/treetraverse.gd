class_name TreeTraverse

static func get_child_of_type(node: Node3D, type) -> Node3D:
	for child in node.get_children():
		if is_instance_of(child, type):
			return child
	return null
