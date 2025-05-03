class_name SlideElementRotate
extends SlideElement

@export var rotation_speed: float


func _slide_process(delta: float) -> void:
	self.rotation += delta * rotation_speed
