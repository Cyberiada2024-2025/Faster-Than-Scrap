extends Node

## Singleton for generating a map in fly phase
## given a sector node properties.
## Additionaly it stores the scene tree of that phase,
## to allow restoring it when returning from the shop.

var _map_node: MapNode
var _scene: Node

var _shop_prefab = preload("res://prefabs/environment/shop_miniature.tscn")


## Called whenever the scene should be procedurally generated (
## when loading fly_phase scene).
## It will restore the map if the _map_node wasn't changed (Useful
## when leaving the shop).
## Also sets the player position
func generate_map() -> void:
	if _scene == null:
		if _map_node == null:
			# create default escape node
			_map_node = MissionNode.new()
			_map_node.mission_info = MissionInfoEscape.new()
			_map_node.mission_info.portal_position = Vector3(0, 0, 15)
		generate_map_from_node()
	get_tree().current_scene.add_child.call_deferred(_scene)
	## TODO SET player position


func generate_map_from_node() -> void:
	_scene = Node3D.new()
	_spawn_shop()
	if _map_node is MissionNode:
		var mission_node: MissionNode = _map_node
		mission_node.mission_info.start(_scene)
		return


func _spawn_shop() -> void:
	var shop = _shop_prefab.instantiate()
	_scene.add_child.call_deferred(shop)
	shop.position = Vector3(12, 0, 0)


func save_fly_scene() -> void:
	_scene = get_tree().current_scene


func set_node(new_node: MapNode) -> void:
	_map_node = new_node
	_scene = null
