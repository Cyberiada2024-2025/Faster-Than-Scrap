extends Node3D


func _random_point_inside_circle() -> Vector3:
	var theta: float = randf() * 2 * PI
	return Vector3(
		cos(theta) * sqrt(randf() * 900000),
		randf_range(1, 6) * -100,
		sin(theta) * sqrt(randf() * 900000)
	)


func _ready() -> void:
	var i = 0
	while i < 20:
		i += 1
		var sprite = Sprite3D.new()
		sprite.texture = load(
			(
				"res://art/textures/environment/layers/nebula_tiles/nebula"
				+ str(randi_range(1, 15))
				+ ".png"
			)
		)
		sprite.position = _random_point_inside_circle()
		sprite.rotation_degrees = Vector3(90, 0, 0)
		#ssprite.render_priority = i
		var scale = 100
		sprite.scale = Vector3(scale, scale, scale)
		add_child(sprite)
