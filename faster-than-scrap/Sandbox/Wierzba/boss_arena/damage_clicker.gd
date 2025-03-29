extends Node3D

@export var damage: Damage = Damage.new(100)


func _get_damageable_from_hit(hit: Dictionary) -> Damageable:
	var rigid_body = hit.get("collider")
	if rigid_body != null and rigid_body is Damageable:
		return rigid_body
	return null


func _get_raycast_hit(event: InputEvent) -> Dictionary:
	var camera3d = get_viewport().get_camera_3d()
	var from = camera3d.project_ray_origin(event.position)
	var to = from + camera3d.project_ray_normal(event.position) * 100
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to, 2)
	query.collide_with_areas = true
	return space_state.intersect_ray(query)


func _input(event: InputEvent):
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.is_pressed()
	):
		var hit := _get_raycast_hit(event)
		var damageable := _get_damageable_from_hit(hit)
		if damageable != null:
			damageable.take_damage(damage, self)
