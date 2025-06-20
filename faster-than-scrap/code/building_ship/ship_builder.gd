class_name ShipBuilder

extends Node3D

## class used in the building ship
## it reacts to mouse clicking for grabbing the module
## and snapping it to the ship if close enough.
signal on_module_select(module: Module)
signal on_module_attach(module: Module)
signal on_module_detach(module: Module)
signal on_module_hover(module: Module)

enum State { NONE, DRAGGING, SETTING_BUTTON }

const RAY_LENGTH = 1000.0

## collider or ares ignored by raycast, might be empty
@export var ignore: Array[CollisionObject3D]
## the mask of checked colliders when checking if there are modules near the mouse
@export var collision_mask: int = 1
## the range of spherecast when checking if there are modules near the mouse
@export var snap_range: float = 1
## material of ghost outline

## borders limiting max size of the ship
@export var ship_borders: Area3D

@export_group("Visuals")
@export var outline_mat: ShaderMaterial
## material for flashing modules
@export var flash_mat: ShaderMaterial
## time of warning flash animation
@export_custom(PROPERTY_HINT_NONE, "suffix:sec") var flash_time: float
@export var choose_key_message: Control
@export var confirm_finish_message: Control

var outline: Array[MeshInstance3D]

var state = State.NONE

var active_module_ghost: ModuleGhost = null
var active_module: Module = null
var attach_target: Module = null
var legal: bool = false

var attach_point_index: int = 0

var mouse_position_3d: Vector3 = Vector3.ZERO

var lmb_was_pressed: bool = false
var lmb_is_pressed: bool = false
var rmb_was_pressed: bool = false
var ignore_rid: Array[RID]
var scene_loader: SceneLoader


func _ready() -> void:
	scene_loader = $SceneLoader

	GameManager.player_ship.position = Vector3.ZERO
	GameManager.player_ship.rotation = Vector3.ZERO

	for ig in ignore:
		ignore_rid.push_back(ig.get_rid())


# ---------------mouse ---------------------------------------------
func _update_mouse_3d_position():
	var camera = get_viewport().get_camera_3d()
	var position_2d = get_viewport().get_mouse_position()
	var drop_plane = Plane(Vector3(0, 1, 0), 0)
	mouse_position_3d = (drop_plane.intersects_ray(
		camera.project_ray_origin(position_2d), camera.project_ray_normal(position_2d)
	))


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


func _update_attach_point_index() -> void:
	if Input.is_key_pressed(KEY_R):
		attach_point_index += 1


# ----------------raycasts hits ------------------------------------
func _get_module_from_hit(hit: Dictionary) -> Module:
	var rigid_body = hit.get("collider")
	if rigid_body != null:
		# may click shop area
		var clicked_shape = rigid_body.get_child(hit["shape"])
		if clicked_shape is Module:
			return clicked_shape
		return null
	return null


func _get_raycast_hit(event: InputEvent) -> Dictionary:
	var camera3d = get_viewport().get_camera_3d()
	var from = camera3d.project_ray_origin(event.position)
	var to = from + camera3d.project_ray_normal(event.position) * RAY_LENGTH
	var space_state = get_world_3d().direct_space_state
	# only first layer (to avoid clicking damageable)
	var query = PhysicsRayQueryParameters3D.create(from, to, 1)
	query.collide_with_areas = true
	query.exclude = ignore_rid
	return space_state.intersect_ray(query)


# ---------------- proximity check ------------------------------------
func _check_colliders_in_range(point: Vector3, radius: float) -> Array[Module]:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	var sphere = SphereShape3D.new()
	sphere.radius = radius

	query.shape = sphere
	query.transform.origin = point
	query.collision_mask = collision_mask  # Adjust mask as needed

	# creates an array of collisions (which contains rigidbody)
	var rigid_body_intersections = space_state.intersect_shape(query)

	# so we need to convert it to get modules
	var modules: Array[Module] = []
	for intersection in rigid_body_intersections:
		modules.append(intersection["collider"].get_child(intersection["shape"]))

	return modules


func _get_module_to_attach() -> Module:
	var modules = _check_colliders_in_range(mouse_position_3d, snap_range)
	# remove held module and ghost from detected collisions
	modules.erase(active_module)
	#modules.erase(active_module_ghost)

	if modules.size() == 0:
		return null

	# find closest module
	var min_distance = INF
	var closest_module = null
	for module in modules:
		var distance = module.global_position.distance_to(mouse_position_3d)
		if distance < min_distance:
			min_distance = distance
			closest_module = module
	return closest_module


func _get_ghost_colliding_modules() -> Array[Module]:
	var overlaping_bodies := active_module_ghost.collided_modules
	# convert to modules
	var modules = []
	for body in overlaping_bodies:
		modules.append(body)
	return []


# --------------------------------


func _position_module(intersection_position: Vector3, intersection_normal: Vector3) -> void:
	var attach_point: Node3D = active_module.get_attach_point(attach_point_index)
	var local_space_offset: Vector3 = attach_point.position
	var angle = atan2(-intersection_normal.z, intersection_normal.x)

	if local_space_offset != Vector3.ZERO:
		active_module_ghost.rotation.y = angle + PI / 2 - attach_point.rotation.y
	else:
		active_module_ghost.rotation.y = angle + PI / 2
	var global_space_offset = (
		active_module_ghost.global_position - active_module_ghost.to_global(local_space_offset)
	)
	active_module_ghost.global_position = intersection_position + global_space_offset


## return whether successfully grabed module
func _on_module_clicked(clicked_module: Module) -> bool:
	if clicked_module == null:
		return false

	if not clicked_module.has_child_module() and clicked_module is not Cockpit:  # cockpit is immovable
		clicked_module.hide()

		# set variables
		active_module = clicked_module
		active_module_ghost = clicked_module.create_ghost()
		attach_point_index = 0

		on_module_select.emit(clicked_module)
		return true
	if clicked_module is Cockpit:
		_flash_module(clicked_module)
	elif clicked_module.has_child_module():
		# flash each child module
		for child in clicked_module.child_modules:
			_flash_module(child)
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
			_dettach_module()
		# if exist delete ghost
		if active_module_ghost != null:
			active_module_ghost.queue_free()
		active_module.show()
		# clear module variables
		active_module_ghost = null
		active_module = null
		print("new state = none")
		state = State.NONE
		outline = []
	else:
		var overlapping = _get_ghost_colliding_modules()
		for module in overlapping:
			_flash_module(module)


## Function for setting up the module, when it is to be attached
## to the ship. It will remove an area3D if exists, and set module
## parameters.
func _attach_module() -> void:
	if active_module.parent_module == null:
		# remove area above module. Ship already has rigidbody,
		# so module is clickable
		var area_parent = active_module.get_parent()
		on_module_attach.emit(active_module)
		active_module.reparent(attach_target.ship)
		area_parent.queue_free()
	else:
		active_module.reparent(attach_target.ship)
		active_module.parent_module.child_modules.erase(active_module)

	var module_was_already_attached: bool = active_module.ship != null
	active_module.set_ship_reference(attach_target.ship)  # copy the reference to the ship
	attach_target.child_modules.append(active_module)
	active_module.parent_module = attach_target

	if module_was_already_attached:
		active_module.on_reattach()
	else:
		active_module.on_attach()


## Function for setting up the module, when it is to be dettached
## from the ship or simply put anywhere "on the floor".
## It will add an area3D if needed to allow clicking the module, and set module
## parameters.
func _dettach_module() -> void:
	if active_module.ship != null:
		active_module.on_detach()

	active_module.set_ship_reference(null)
	if active_module.parent_module != null:
		on_module_detach.emit(active_module)
		active_module.parent_module.child_modules.erase(active_module)
		active_module.parent_module = null

		# add some area3d as a root of the module, to allow clicking it
		active_module.reparent(get_tree().get_root())
		var area = Area3D.new()
		get_tree().current_scene.add_child(area)
		area.position = active_module.position
		active_module.reparent(area)


func _can_module_have_assigned_key(active_module: Module) -> bool:
	return (
		active_module.is_activable
		or (active_module.module_name == "Cockpit" and SettingsManager.brakes_enabled == true)
	)


func _input(event: InputEvent):
	_update_lmb_state(event)
	_update_mouse_3d_position()
	_update_attach_point_index()

	## TODO add some display in UI in which state the player is

	match state:
		State.NONE:
			if confirm_finish_message.visible || choose_key_message.visible:
				return
			if _lmb_just_pressed():
				var hit := _get_raycast_hit(event)
				if hit.size() > 0:
					var clicked_module: Module = _get_module_from_hit(hit)
					if _on_module_clicked(clicked_module):
						state = State.DRAGGING
						outline = _create_outline(active_module_ghost)
						print("new state = dragging")
			elif _rmb_just_pressed(event):
				var hit := _get_raycast_hit(event)
				if hit.size() > 0:
					active_module = _get_module_from_hit(hit)
					if _can_module_have_assigned_key(active_module):
						state = State.SETTING_BUTTON
						choose_key_message.visible = true
						print("new state = setting button")
			elif event is InputEventMouse:
				var hit := _get_raycast_hit(event)
				if hit.size() > 0:
					var hovered_module: Module = _get_module_from_hit(hit)
					on_module_hover.emit(hovered_module)
				else:
					on_module_hover.emit(null)
		State.DRAGGING:
			if confirm_finish_message.visible || choose_key_message.visible:
				return
			if _lmb_just_pressed():
				_on_lmb_release()
		State.SETTING_BUTTON:
			## check if keyboard pressed
			if event is InputEventKey and event.pressed:
				var key_event: InputEventKey = event
				if not key_event.keycode in active_module.reserved_keys:
					active_module.change_key(key_event.keycode)
					state = State.NONE
					choose_key_message.visible = false
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
	var query = (
		PhysicsRayQueryParameters3D
		. create(
			mouse_position_3d,
			attach_target.global_position,
			~0,  # collision mask: ~0 means 0xFFFFFFFF (full collision mask)
		)
	)
	var intersection = space_state.intersect_ray(query)

	if intersection.size() == 0:
		return intersection

	# now find the intersection using the face normal
	var query2 = (
		PhysicsRayQueryParameters3D
		. create(
			mouse_position_3d,
			mouse_position_3d - intersection.normal * 10,
			~0,  # collision mask: ~0 means 0xFFFFFFFF (full collision mask)
		)
	)
	var intersection2 = space_state.intersect_ray(query2)

	if intersection2.size() == 0:
		return intersection2

	var second_hit: Module = _get_module_from_hit(intersection2)
	if second_hit == attach_target:
		return intersection2
	return {}


# check whether the active module collides with other modules
func _module_collides() -> bool:
	return active_module_ghost.collided_modules.size() > 0


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
				_display_legal_not_attached()
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
			elif ship_borders.overlaps_area(active_module_ghost):
				_display_illegal()
				legal = false
			else:
				_display_legal()
				legal = true


# allow build
# display in ui as legal
func _display_legal() -> void:
	outline_mat.set_shader_parameter("Color", Color.GREEN)


# allow build
# display in ui as legal, but not attached to the ship
func _display_legal_not_attached() -> void:
	outline_mat.set_shader_parameter("Color", Color.ORANGE)


# do not allow build
# display in ui as illegal or invalid position
func _display_illegal() -> void:
	outline_mat.set_shader_parameter("Color", Color.RED)


func _create_outline(parent: Node3D) -> Array[MeshInstance3D]:
	var module_meshes = parent.find_children("*", "MeshInstance3D", true, false)

	var out: Array[MeshInstance3D] = []
	for module_mesh in module_meshes:
		#var mesh = MeshInstance3D.new()
		var mesh: MeshInstance3D = module_mesh.duplicate()
		parent.add_child(mesh)
		mesh.material_override = outline_mat
		mesh.global_rotation = module_mesh.global_rotation
		mesh.global_scale(module_mesh.global_transform.basis.get_scale())
		out.append(mesh)

	return out


func _flash_module(module: Module) -> void:
	var flashes = _create_outline(module)
	for flash in flashes:
		flash.material_override = flash_mat
		var tween = get_tree().create_tween().bind_node(flash).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(
			flash, "material_override:shader_parameter/Color", Color.RED, flash_time / 2
		)
		tween.tween_property(
			flash, "material_override:shader_parameter/Color", Color.BLACK, flash_time / 2
		)
		tween.tween_callback(flash.queue_free)
		tween.play()


func _on_finish_pressed() -> void:
	confirm_finish_message.visible = true


func _on_confirm_pressed() -> void:
	confirm_finish_message.visible = false
	scene_loader.load_fly_ship_scene()


func _on_deny_pressed() -> void:
	confirm_finish_message.visible = false
