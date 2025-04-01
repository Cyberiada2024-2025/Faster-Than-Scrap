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

var selected: bool = false

var angle: float = 0
var arc_count: int = 10


func _process(_delta: float) -> void:
	queue_redraw()
	if Engine.is_editor_hint():
		return
	angle += _delta


func _draw() -> void:
	_set_color()
	_draw_connections()
	if selected:
		draw_selected()


func _draw_connections() -> void:
	var local_start = get_rect().get_center() - get_rect().position
	for next_node in next_map_nodes:
		if next_node != null:
			var offset = (
				# offset between beggings of rects
				Vector2(next_node.global_position.x - global_position.x, 0)
				# offset to center of next node
				+ (next_node.get_rect().get_center() - next_node.get_rect().position)
				+ next_node.get_rect().position
				- get_rect().position
			)
			draw_line(local_start, offset, Color.BLACK, 8.0)


## change color according to node type
func _set_color() -> void:
	if active:
		modulate = Color.WHITE
		draw_active()
		return
	if finished:
		modulate = Color.GRAY
		draw_finished()


func draw_finished():
	var local_start = get_rect().get_center() - get_rect().position
	var radius = get_rect().size.x / 2

	# draw / line
	draw_line(
		local_start + Vector2(-radius, -radius),
		local_start + Vector2(radius, radius),
		Color.RED,
		8.0
	)

	# draw \ line
	draw_line(
		local_start + Vector2(-radius, radius),
		local_start + Vector2(radius, -radius),
		Color.RED,
		8.0
	)


func draw_active():
	var local_start = get_rect().get_center() - get_rect().position
	var radius = get_rect().size.x / 2

	var delta_angle = PI / arc_count
	for i in range(arc_count):
		var start_angle = 2 * PI * (i) / arc_count

		draw_arc(
			local_start,
			radius,
			start_angle + angle,
			start_angle + delta_angle + angle,
			5,
			Color.GRAY,
			8
		)


func draw_selected():
	var local_start = get_rect().get_center() - get_rect().position
	var radius = (get_rect().size.x / 2) * (3.0 / 4)

	draw_arc(local_start, radius, angle, 2 * PI + angle, 5, Color.GRAY, 8)


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


func change_scene(_scene_loader: SceneLoader) -> void:
	pass
