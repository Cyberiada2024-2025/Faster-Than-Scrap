class_name MapLayer
extends VBoxContainer

var nodes: Array[MapNode] = []


func _enter_tree() -> void:
	for node in get_children():
		nodes.append(node)
