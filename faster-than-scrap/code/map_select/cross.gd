class_name Cross
extends Control

var shown: bool = false


func show_cross() -> void:
	shown = true
	queue_redraw()


func _draw() -> void:
	if !shown:
		return

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
