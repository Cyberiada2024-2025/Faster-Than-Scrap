class_name ShipBuilder

extends Node3D

const RAY_LENGTH = 1000.0

var active_module: Module = null
var mouse_position_3d: Vector3 = Vector3.ZERO

var lmb_was_pressed: bool = false
var lmb_is_pressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_mouse_3d_position():
	var camera = $Camera3D
	var position2D = get_viewport().get_mouse_position()
	var dropPlane  = Plane(Vector3(0, 1, 0), 0)
	mouse_position_3d = dropPlane.intersects_ray(camera.project_ray_origin(position2D),camera.project_ray_normal(position2D))

func get_module_from_hit(hit:Dictionary) -> Module:
	var rigid_body : RigidBody3D = hit.get("collider")
	var module : Module = rigid_body.get_parent()
	if module is Module:
		print("CLICKED " + module.name)
		return module
	return null
	
func lmb_just_pressed():
	
	return !lmb_was_pressed and lmb_is_pressed

func lmb_just_released():
	return lmb_was_pressed and !lmb_is_pressed

## custom function for detecting mouse lmb state
func check_lmb_state(event: InputEvent) -> void:
	lmb_was_pressed = lmb_is_pressed
	if event is InputEventMouseButton and event.button_index == 1:
		lmb_is_pressed = event.is_pressed()

func _input(event: InputEvent):
	check_lmb_state(event)
	get_mouse_3d_position()
	if lmb_just_pressed():
		var camera3d = $Camera3D
		var from = camera3d.project_ray_origin(event.position)
		var to = from + camera3d.project_ray_normal(event.position) * RAY_LENGTH
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = true
		var hit := space_state.intersect_ray(query)
		if hit.size() > 0:
			active_module = get_module_from_hit(hit)
	if lmb_just_released():
		active_module=null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active_module != null:
		active_module.position = mouse_position_3d
		
	
