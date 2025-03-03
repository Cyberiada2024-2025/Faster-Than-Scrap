@tool

class_name BossNode

extends MapNode

func _set_color() -> void:
	super()
	modulate = Color.RED


func get_description() -> String:
	return "Mission Type: \nBoss"
