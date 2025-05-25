extends Sprite2D

@export var follow_speed: float = 3.0

func _process(delta):
	var target_position = get_global_mouse_position()
	position = position.lerp(target_position, follow_speed * delta)
