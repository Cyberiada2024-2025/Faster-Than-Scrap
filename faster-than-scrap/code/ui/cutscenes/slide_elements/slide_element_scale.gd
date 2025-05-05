class_name SlideElementScale
extends SlideElement

# in radians
@export var scale_speed: Vector2


func _slide_process(delta: float) -> void:
	scale += delta * scale_speed
