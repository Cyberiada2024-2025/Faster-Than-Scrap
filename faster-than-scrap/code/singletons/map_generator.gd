extends Node

## Singleton for generating a map in fly phase
## given a sector node properties.
## Additionaly it stores the scene tree of that phase,
## to allow restoring it when returning from the shop.

var _map_node: MapNode = null
var _scene: Node = null

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


func detach_and_save_current_scene() -> void:
	_scene = get_tree().current_scene
	_scene.get_parent().remove_child(_scene)


func try_attach_saved_scene() -> bool:
	if _scene == null:
		return false
	get_tree().current_scene.queue_free()
	get_tree().get_root().add_child(_scene)
	get_tree().current_scene = _scene
	_scene = null
	return true


func swap_saved_and_current_scene() -> bool:
	if _scene == null:
		return false
	var _temp_scene = get_tree().current_scene
	_temp_scene.get_parent().remove_child(_temp_scene)

	#get_tree().current_scene.queue_free() # queue free removes completly
	var x = get_tree()
	var y = get_tree().get_root()
	get_tree().get_root().add_child(_scene)
	get_tree().current_scene = _scene
	_scene = _temp_scene
	return true


func set_node(new_node: MapNode) -> void:
	_map_node = new_node
	_scene = null


## called when the game's ended
func reset() -> void:
	_map_node = null
	_scene = null
