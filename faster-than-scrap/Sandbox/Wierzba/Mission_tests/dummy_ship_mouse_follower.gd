class_name DummyShipMouseFollower

extends PlayerShip


func _ready() -> void:
	GameManager.player_ship = self


func _process(_delta: float) -> void:
	var camera = get_viewport().get_camera_3d()
	var position_2d = get_viewport().get_mouse_position()
	var drop_plane = Plane(Vector3(0, 1, 0), 0)
	global_position = (drop_plane.intersects_ray(
		camera.project_ray_origin(position_2d), camera.project_ray_normal(position_2d)
	))
