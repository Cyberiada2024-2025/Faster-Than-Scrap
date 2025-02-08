class_name ShipBuilder

extends Node3D

const RAY_LENGTH = 1000.0

var active_module_ghost: Area3D = null
var active_module: Module = null
var attach_target: Node3D = null
var legal: bool = false

var attach_point_index : int = 0

var mouse_position_3d: Vector3 = Vector3.ZERO

var lmb_was_pressed: bool = false
var lmb_is_pressed: bool = false

# mouse ---------------------------------------------
func _get_mouse_3d_position():
	var camera = $Camera3D
	var position2D = get_viewport().get_mouse_position()
	var dropPlane  = Plane(Vector3(0, 1, 0), 0)
	mouse_position_3d = dropPlane.intersects_ray(camera.project_ray_origin(position2D),camera.project_ray_normal(position2D))
	
func _lmb_just_pressed():
	return !lmb_was_pressed and lmb_is_pressed

func _lmb_just_released():
	return lmb_was_pressed and !lmb_is_pressed

## custom function for detecting mouse lmb state
func _check_lmb_state(event: InputEvent) -> void:
	lmb_was_pressed = lmb_is_pressed
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		lmb_is_pressed = event.is_pressed()
func _check_attach_point_index(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
		attach_point_index += 1
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
		attach_point_index -= 1
# raycasts hits ------------------------------------

func _get_module_from_hit(hit:Dictionary) -> Module:
	var rigid_body : RigidBody3D = hit.get("collider")
	if rigid_body is Module:
		return rigid_body
	return null

func _get_hit(event: InputEvent) -> Dictionary:
	var camera3d = $Camera3D
	var from = camera3d.project_ray_origin(event.position)
	var to = from + camera3d.project_ray_normal(event.position) * RAY_LENGTH
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	return space_state.intersect_ray(query)



func _module_has_child_module(module: Module)->bool:
	for child in module.get_children():
		if child is Module:
			return true
	return false


func _check_colliders_in_range(point: Vector3, radius: float) -> Array:
	var space_state = get_world_3d().direct_space_state
	
	var query = PhysicsShapeQueryParameters3D.new()
	var sphere = SphereShape3D.new()
	sphere.radius = radius
	
	query.shape = sphere
	query.transform.origin = point
	query.collision_mask = 1  # Adjust mask as needed

	var result = space_state.intersect_shape(query)
	return result  # Returns an array of dictionaries with collider info

func _get_module_to_attach()->Module:
	var colliders = _check_colliders_in_range(mouse_position_3d,1)
	# remove held module from detected collisions
	for i in range(colliders.size()):
		if colliders[i].collider == active_module or colliders[i].collider == active_module_ghost:
			colliders.remove_at(i)
			break
	
	if colliders.size() == 0:
		return null
	
	var min_distance = INF
	var closest_rigidbody = null
	for coll in colliders:
		var distance = coll.collider.global_position.distance_to(mouse_position_3d)
		if distance < min_distance:
			min_distance = distance
			closest_rigidbody = coll.collider
	return closest_rigidbody


# --------------------------------

func _position_module(intersection_position: Vector3, intersection_normal: Vector3)->void:
	print(attach_point_index)
	var attach_point : Node3D = active_module.get_attach_point(attach_point_index)
	var local_space_offset: Vector3 = attach_point.position
	var angle = atan2(-intersection_normal.z, intersection_normal.x)
	
	if local_space_offset != Vector3.ZERO:
		active_module_ghost.rotation.y = angle + PI/2 - attach_point.rotation.y
	else:
		active_module_ghost.rotation.y = angle + PI/2
	var global_space_offset = active_module_ghost.global_position - active_module_ghost.to_global(local_space_offset)
	active_module_ghost.global_position=intersection_position + global_space_offset


func _input(event: InputEvent):
	_check_lmb_state(event)
	_get_mouse_3d_position()
	_check_attach_point_index(event)
	if _lmb_just_pressed():
		var hit := _get_hit(event)
		if hit.size() > 0:
			var clicked_module := _get_module_from_hit(hit)
			if not _module_has_child_module(clicked_module):
				var name = clicked_module.name # godot renames to Node3D after reparenting :/
				# change parent to root scene
				clicked_module.reparent(get_tree().get_root())
				clicked_module.name = name
				# set variables
				active_module = clicked_module
				active_module_ghost = clicked_module.create_ghost()
				attach_point_index = 0
	if _lmb_just_released():
		if legal and active_module_ghost != null:
			active_module.global_position = active_module_ghost.global_position
			active_module.global_rotation = active_module_ghost.global_rotation
			if attach_target != null:
				active_module.reparent(attach_target)
		if active_module_ghost != null:
			active_module_ghost.queue_free()
		active_module_ghost = null
		active_module = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# if dragging
	if active_module != null:
		active_module_ghost.global_position = mouse_position_3d
		# check if can attach to anything
		attach_target = _get_module_to_attach()
		if attach_target == null:
			# legal because player wants to detach the active module
			legal = true
			return

		# check collisions
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(
			active_module_ghost.global_position,
			attach_target.global_position,~0, [active_module.get_rid()]) # ignore active_module
		var intersections = space_state.intersect_ray(query)
		
		if intersections.size() == 0:
			# mouse inside other module
			# do not allow build
			# display in ui as illegal or invalid position
			legal = false
		else:
			_position_module(intersections.position,intersections.normal)
			var overlapping = active_module_ghost.get_overlapping_bodies()
			ListUtils.remove(overlapping,attach_target)
			ListUtils.remove(overlapping,active_module)
			if overlapping.size() > 0:
				# Module colliding with other module
				# do not allow build
				# display in ui as illegal or invalid position
				legal = false
				return
			legal = true
				
