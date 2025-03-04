@tool
class_name MapNode

extends TextureButton

signal clicked(MapNode)

## Map node for map selector. Map node is a circle
## indicating what the player will come across in the future.

@export var next_map_nodes: Array[MapNode] = []
## if the player just finished that node
@export var active: bool = false
## if player came through that node
@export var finished: bool = false

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	_set_color()
	_draw_connections()

func _draw_connections() -> void:
	var local_start = get_rect().get_center() - get_rect().position
	for next_node in next_map_nodes:
		if next_node != null:
			var offset = (
				Vector2(next_node.global_position.x - global_position.x,0) # offset between beggings of rects
				+ (next_node.get_rect().get_center() - next_node.get_rect().position) # offset to center of next node
				 + next_node.get_rect().position - get_rect().position
				)
			draw_line(
				local_start,
				offset, 
				Color.BLACK, 8.0)

## change color according to node type
func _set_color() -> void:
	if active:
		modulate = Color.WHITE
		return
	if finished:
		modulate = Color.GRAY

func on_click() -> void:
	clicked.emit(self)

func on_hover_enter() -> void:
	pass

func on_hover_leave() -> void:
	pass

func get_description() -> String:
	return ""

func is_after_node(before_node: MapNode) -> bool:
	for node in before_node.next_map_nodes:
		if node == self:
			return true
	return false

func change_scene(sceneLoader: SceneLoader) -> void:
	pass
