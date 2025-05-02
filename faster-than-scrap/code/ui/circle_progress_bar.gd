class_name CircleProgressBar
extends Control

var circle_radius: float = 30
var circle_width: float = 10

var _percentage: float = 0


func set_percentage(percentage: float):
	_percentage = percentage
	queue_redraw()


func _draw() -> void:
	var end_angle = 2.0 * PI * _percentage
	draw_arc(Vector2.ZERO, circle_radius, 0, end_angle, 30, Color.GRAY, circle_width)
