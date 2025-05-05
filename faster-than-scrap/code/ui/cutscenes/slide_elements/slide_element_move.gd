class_name SlideElementMove
extends SlideElement

@export var speed: Vector2


func _slide_process(delta: float) -> void:
	position += delta * speed
