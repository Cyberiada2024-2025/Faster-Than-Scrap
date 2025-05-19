extends SpawnerWeapon

const ANIM: String = "Flash"

@export var warning_time: float = 2.0
@export var animator: AnimationPlayer

@export var zero_y_pos: bool
@export var graphics: Node3D


func _ready() -> void:
	# wait one frame, so weapon can get us in position
	await get_tree().process_frame
	animator.play(ANIM, -1.0, 1.0/warning_time)

	# puts graphics on y=0 plane at point we are looking at
	# this is for vortex spike attack really
	# no I don't know why /5 has to be there
	if zero_y_pos && graphics != null:
		graphics.position.z = -abs(position.y)/sin(PI/2-basis.get_euler().x)/5
		graphics.global_rotation = Vector3.ZERO

	await get_tree().create_timer(warning_time).timeout

	var new_projectile = _spawn_projectile()
	new_projectile.transform = global_transform
	get_tree().current_scene.add_child(new_projectile)

	if muzzle_flash != null:
		muzzle_flash.restart()
		muzzle_flash.emitting = true

	queue_free()
