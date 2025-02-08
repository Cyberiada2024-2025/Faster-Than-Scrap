class_name ListUtils

## removes an element from the given list
## removes only the first one found, if there are multple copies
static func remove(list: Array, element) -> void:
	for i in range(list.size()):
		if list[i] == element:
			list.remove_at(i)
			return
