class_name ArrayUtils


## Removes an element from the given aray, if the field matches the desired value
## Removes only the first one found, if there are multple copies
static func remove_by_field(array: Array, field_name: String, field_value) -> void:
	for i in range(array.size()):
		if array[i][field_name] == field_value:
			array.remove_at(i)
			return


## Returns the minimum value of the array, with a custom comparator
static func min_custom(array: Array, cmp: Callable):
	return array.reduce(func(a, b): return a if not cmp.call(b, a) else b)


## Returns the maximum value of the array, with a custom comparator
static func max_custom(array: Array, cmp: Callable):
	return array.reduce(func(a, b): return a if not -cmp.call(b, a) else b)
