@tool

class_name FinishNode

extends MapNode

func _set_color() -> void:
	super()
	modulate = Color.BLACK

func get_description() -> String:
	return "Mission Type: \nTHE END"
