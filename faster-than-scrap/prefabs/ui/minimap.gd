extends MeshInstance3D

# Store the original position and screen position
var original_world_position: Vector3
var original_screen_position: Vector2
var original_distance: float
var reference_fov: float
var camera


func _ready():
	camera = get_viewport().get_camera_3d()
	if camera == null:
		return

	original_world_position = global_position
	original_screen_position = camera.unproject_position(global_position)
	original_distance = (global_position - camera.global_position).length()


func _process(delta):
	var ray_origin = camera.project_ray_origin(original_screen_position)
	var ray_direction = camera.project_ray_normal(original_screen_position)
	global_position = ray_origin + ray_direction * original_distance
