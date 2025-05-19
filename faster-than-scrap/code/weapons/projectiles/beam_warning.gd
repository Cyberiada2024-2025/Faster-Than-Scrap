extends SpawnerWeapon

const ANIM: String = "Flash"

@export var warning_time: float = 2.0
@export var animator: AnimationPlayer

var active_projectile: Node3D

func _ready() -> void:
	# wait one frame, so weapon can get us in position
	await get_tree().process_frame
	animator.play(ANIM, -1, 1/warning_time)

	await get_tree().create_timer(warning_time).timeout

	active_projectile = _spawn_projectile()
	add_child(active_projectile)
	if muzzle_flash != null:
		muzzle_flash.emitting = true

func _notification(notification):
	if (notification == NOTIFICATION_PREDELETE):
		active_projectile.queue_free()
