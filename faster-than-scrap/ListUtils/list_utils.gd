class_name ListUtils

## removes an element from the given list
## removes only the first one found, if there are multple copies
static func remove(list: Array, element) -> void:
	for i in range(list.size()):
		if list[i] == element:
			list.remove_at(i)
			return


## removes an element from the given list, if the field matches the desired value
## removes only the first one found, if there are multple copies
static func remove_by_field(list: Array, field_name: String, field_value) -> void:
	for i in range(list.size()):
		if list[i][field_name] == field_value:
			list.remove_at(i)
			return
