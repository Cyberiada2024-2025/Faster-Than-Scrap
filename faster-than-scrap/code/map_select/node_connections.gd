class_name NodeConnections
extends Control

@export var node: MapNode

var time: float = 0


func _process(delta: float) -> void:
	queue_redraw()
	time += delta


func _draw() -> void:
	_draw_connections()


#region connections
func _draw_connections() -> void:
	var local_start = node.get_rect().get_center() - node.get_rect().position

	for next_node in node.next_map_nodes:
		if next_node != null:
			var offset = (
				# offset between beggings of rects
				Vector2(next_node.global_position.x - global_position.x, 0)
				# offset to center of next node
				+ (next_node.get_rect().get_center() - next_node.get_rect().position)
				+ next_node.get_rect().position
				- node.get_rect().position
			)
			_draw_connection(local_start, offset, next_node)


func _draw_connection(start: Vector2, end: Vector2, next_node: MapNode) -> void:
	if node.active:
		_draw_next_sector_line(start, end)
		return

	if node.finished and (next_node.finished or next_node.active):
		_draw_finished_sector_line(start, end)
		return

	_draw_default_line(start, end)


func _draw_next_sector_line(start: Vector2, end: Vector2) -> void:
	const SEGMENT_LENGTH: float = 10.0
	const FREQUENCY: float = 1
	var line_length = (end - start).length()
	var cursor: Vector2 = start
	var segment_offset = 2 * SEGMENT_LENGTH * fmod(time, FREQUENCY) / FREQUENCY
	var draw_direction = (end - start).normalized()

	cursor += segment_offset * draw_direction

	while start.distance_to(cursor) <= line_length:
		draw_line(cursor, cursor + draw_direction * SEGMENT_LENGTH, Color.CORAL, 8.0)
		cursor += draw_direction * SEGMENT_LENGTH * 2


func _draw_finished_sector_line(start: Vector2, end: Vector2) -> void:
	draw_line(start, end, Color.CORAL, 4.0)


func _draw_default_line(start: Vector2, end: Vector2) -> void:
	const SEGMENT_LENGTH: float = 4.0
	const INCREMENT_FACTOR: float = 5  # how many segment length should be added to cursor
	var line_length = (end - start).length()
	var cursor: Vector2 = start
	var draw_direction = (end - start).normalized()

	cursor += draw_direction

	while start.distance_to(cursor) <= line_length:
		draw_line(cursor, cursor + draw_direction * SEGMENT_LENGTH, Color.PAPAYA_WHIP, 4.0)
		cursor += draw_direction * SEGMENT_LENGTH * INCREMENT_FACTOR

#endregion
