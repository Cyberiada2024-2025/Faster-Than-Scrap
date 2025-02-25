class_name ShipBuilder

extends Node3D

## class used in the building ship
## it reacts to mouse clicking for grabbing the module
## and snapping it to the ship if close enough.

enum State {NONE, DRAGGING, SETTING_BUTTON}

const RAY_LENGTH = 1000.0

## the mask of checked colliders when checking if there are modules near the mouse
@export var collision_mask: int = 1
## the range of spherecast when checking if there are modules near the mouse
@export var snap_range: float = 1

var state = State.NONE

var active_module_ghost: Area3D = null
var active_module: Module = null
var attach_target: Node3D = null
var legal: bool = false

var attach_point_index: int = 0

var mouse_position_3d: Vector3 = Vector3.ZERO

var lmb_was_pressed: bool = false
var lmb_is_pressed: bool = false
var rmb_was_pressed: bool = false

# ---------------mouse ---------------------------------------------
func _update_mouse_3d_position():
	var camera = get_viewport().get_camera_3d()
	var position_2d = get_viewport().get_mouse_position()
	var drop_plane = Plane(Vector3(0, 1, 0), 0)
	mouse_position_3d = (
		drop_plane.intersects_ray(
			camera.project_ray_origin(position_2d),
			camera.project_ray_normal(position_2d)
		)
	)

func _lmb_just_pressed() -> bool:
	return !lmb_was_pressed and lmb_is_pressed

func _rmb_just_pressed(event: InputEvent) -> bool:
	var pressed = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT
	var just_pressed: bool = pressed and not rmb_was_pressed
	rmb_was_pressed = pressed
	return just_pressed

# custom function for detecting mouse lmb state
func _update_lmb_state(event: InputEvent) -> void:
	lmb_was_pressed = lmb_is_pressed
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		lmb_is_pressed = event.is_pressed()

func _update_attach_point_index(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			attach_point_index += 1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			attach_point_index -= 1

# ----------------raycasts hits ------------------------------------
func _get_module_from_hit(hit:Dictionary) -> Module:
	var rigid_body: RigidBody3D = hit.get("collider")
	if rigid_body is Module:
		return rigid_body
	return null

func _get_raycast_hit(event: InputEvent) -> Dictionary:
	var camera3d = get_viewport().get_camera_3d()
	var from = camera3d.project_ray_origin(event.position)
	var to = from + camera3d.project_ray_normal(event.position) * RAY_LENGTH
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	return space_state.intersect_ray(query)

# ---------------- proximity check ------------------------------------
func _check_colliders_in_range(point: Vector3, radius: float) -> Array:
	var space_state = get_world_3d().direct_space_state

	var query = PhysicsShapeQueryParameters3D.new()
	var sphere = SphereShape3D.new()
	sphere.radius = radius

	query.shape = sphere
	query.transform.origin = point
	query.collision_mask = collision_mask # Adjust mask as needed

	var result = space_state.intersect_shape(query)
	return result  # Returns an array of dictionaries with collider info

func _get_module_to_attach() -> Module:
	var colliders = _check_colliders_in_range(mouse_position_3d, snap_range)
	# remove held module and ghost from detected collisions
	ArrayUtils.remove_by_field(colliders, "collider", active_module)
	ArrayUtils.remove_by_field(colliders, "collider", active_module_ghost)

	if colliders.size() == 0:
		return null

	# find closest module
	var min_distance = INF
	var closest_rigidbody = null
	for coll in colliders:
		var distance = coll.collider.global_position.distance_to(mouse_position_3d)
		if distance < min_distance:
			min_distance = distance
			closest_rigidbody = coll.collider
	return closest_rigidbody

# --------------------------------

func _position_module(intersection_position: Vector3, intersection_normal: Vector3) -> void:
	var attach_point: Node3D = active_module.get_attach_point(attach_point_index)
	var local_space_offset: Vector3 = attach_point.position
	var angle = atan2(-intersection_normal.z, intersection_normal.x)

	if local_space_offset != Vector3.ZERO:
		active_module_ghost.rotation.y = angle + PI/2 - attach_point.rotation.y
	else:
		active_module_ghost.rotation.y = angle + PI/2
	var global_space_offset = (
		active_module_ghost.global_position -
		active_module_ghost.to_global(local_space_offset)
	)
	active_module_ghost.global_position = intersection_position + global_space_offset

## return whether successfully grabed module
func _on_module_clicked(clicked_module: Module) -> bool:
	if (clicked_module != null
		and not clicked_module.has_child_module()
		and clicked_module is not Cockpit): # cockpit is immovable
		clicked_module.hide()

		# set variables
		active_module = clicked_module
		active_module_ghost = clicked_module.create_ghost()
		attach_point_index = 0
		return true
	return false

func _on_lmb_release() -> void:
	# if legal position, set the module's position
	if legal and active_module_ghost != null:
		active_module.global_position = active_module_ghost.global_position
		active_module.global_rotation = active_module_ghost.global_rotation
		# if there is a attach target, reparent to it
		if attach_target != null:
			_attach_module()
		else:
			active_module.reparent(get_tree().get_root())
			active_module.set_ship_reference(null)
			_remove_joint()
	# if exist delete ghost
	if active_module_ghost != null:
		active_module_ghost.queue_free()
	active_module.show()
	# clear module variables
	active_module_ghost = null
	active_module = null

func _remove_joint() -> void:
	if active_module.joint != null:
		active_module.joint.queue_free()
		active_module.joint = null

func _add_joint() -> void:
	_remove_joint()
	active_module.joint = preload("res://prefabs/modules/joint.tscn").instantiate()
	active_module.add_child(active_module.joint)
	active_module.joint.name = "Joint"
	active_module.joint.node_a = active_module.get_path()
	active_module.joint.node_b = attach_target.get_path()

func _attach_module() -> void:
	active_module.reparent(attach_target)
	active_module.set_ship_reference(attach_target.ship)  # copy the reference to the ship
	_add_joint()

func _input(event: InputEvent):
	_update_lmb_state(event)
	_update_mouse_3d_position()
	_update_attach_point_index(event)

	## TODO add some display in UI in which state the player is

	match state:
		State.NONE:
			if _lmb_just_pressed():
				var hit := _get_raycast_hit(event)
				if hit.size() > 0:
					var clicked_module := _get_module_from_hit(hit)
					if _on_module_clicked(clicked_module):
						state = State.DRAGGING
						print("new state = dragging")
			elif _rmb_just_pressed(event):
				var hit := _get_raycast_hit(event)
				if hit.size() > 0:
					active_module = _get_module_from_hit(hit)
					state = State.SETTING_BUTTON
					print("new state = setting button")
		State.DRAGGING:
			if _lmb_just_pressed():
				_on_lmb_release()
				print("new state = none")
				state = State.NONE
		State.SETTING_BUTTON:
			## check if keyboard pressed
			if event is InputEventKey and event.pressed:
				var key_event: InputEventKey = event
				active_module.activation_key = key_event.keycode
				state = State.NONE
				print("new state = none")

#        +------------+
#        |     .      |
#        +----/|------+
#          | / V normal vector
#   second |/ first raycast
#          .
# find intersection point to snap module
func _get_intersection() -> Dictionary:
	# first find intersection with the attach target to find the face normal
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		mouse_position_3d,
		attach_target.global_position,
		~0,  # collision mask: ~0 means 0xFFFFFFFF (full collision mask)
		[active_module.get_rid()]
	)  # ignore active_module
	var intersection = space_state.intersect_ray(query)

	if intersection.size() == 0:
		return intersection

	# now find the intersection using the face normal
	var query2 = PhysicsRayQueryParameters3D.create(
		mouse_position_3d,
		mouse_position_3d - intersection.normal * 10,
		~0,  # collision mask: ~0 means 0xFFFFFFFF (full collision mask)
		[active_module.get_rid()]
	)  # ignore active_module
	var intersection2 = space_state.intersect_ray(query2)

	if intersection2.size() == 0:
		return intersection2

	if intersection2.collider == attach_target:
		return intersection2
	return {}

# check whether the active module collides with other modules
func _module_collides() -> bool:
	var overlapping = active_module_ghost.get_overlapping_bodies()
	overlapping.erase(attach_target)
	overlapping.erase(active_module)
	return overlapping.size() > 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# if dragging
	if state == State.DRAGGING and active_module != null:
		_position_module(mouse_position_3d, Vector3.BACK)
		#active_module_ghost.global_position = mouse_position_3d
		# check if can attach to anything
		attach_target = _get_module_to_attach()
		if attach_target == null:
			if _module_collides():
				# Module colliding with other module
				_display_illegal()
				legal = false
			else:
				legal = true
			return

		# find the point on the attach target where can the module be snapped
		var intersection = _get_intersection()

		if intersection.size() == 0:
			# module inside other attach target
			_display_illegal()
			legal = false
		else:
			_position_module(intersection.position, intersection.normal)
			if _module_collides():
				# Module colliding with other module
				_display_illegal()
				legal = false
			else:
				legal = true

# allow build
# display in ui as legal
func _display_legal() -> void:
	pass

# do not allow build
# display in ui as illegal or invalid position
func _display_illegal() -> void:
	pass
