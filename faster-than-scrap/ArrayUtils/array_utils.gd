class_name ArrayUtils

## removes an element from the given list, if the field matches the desired value
## removes only the first one found, if there are multple copies
static func remove_by_field(array: Array, field_name: String, field_value) -> void:
	for i in range(array.size()):
		if array[i][field_name] == field_value:
			array.remove_at(i)
			return
