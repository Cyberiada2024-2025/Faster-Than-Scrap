extends Node

## Singleton for generating a map in fly phase
## given a sector node properties.
## Additionaly it stores the scene tree of that phase,
## to allow restoring it when returning from the shop.

var _map_node: MapNode
var _scene: Node


## Called whenever the scene should be procedurally generated (
## when loading fly_phase scene).
## It will restore the map if the _map_node wasn't changed (Useful
## when leaving the shop).
func generate_map() -> void:
	if _scene == null:
		_scene = _scene
	get_tree().root.add_child(_scene)


func set_node(new_node: MapNode) -> void:
	_map_node = new_node
	_scene = null
