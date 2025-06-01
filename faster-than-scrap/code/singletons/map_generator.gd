extends Node

## Singleton for generating a map in fly phase
## given a sector node properties.
## Additionaly it stores the scene tree of that phase,
## to allow restoring it when returning from the shop.

var _map_node: MapNode = null
var _scene: Node = null


func _spawn_vortex(mission_info: MissionInfo) -> void:
	SpaceVortex.spawn_vortex(mission_info.get_mission_final_target_position())


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


func set_node(new_node: MapNode) -> void:
	_map_node = new_node
	_scene = null


## called when the game's ended
func reset() -> void:
	_map_node = null
	_scene = null
