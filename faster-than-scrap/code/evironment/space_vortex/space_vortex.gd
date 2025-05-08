extends Area3D

const VORTEX_TIMER_PATH: String = "res://prefabs/environment/space_vortex/inside_vortex_timer.tscn"
const TIMER_NAME: String = "VortexTimer926452"

const START_SCALE: float = 100
const MIN_SCALE: float = 0.001
const SHRINKING_TIME: float = 60  # in second
const SHRINK_SPEED: float = (START_SCALE - MIN_SCALE) / SHRINKING_TIME  # units per seconds


static func spawn_vortex(start_position: Vector3) -> void:
	pass


func _ready() -> void:
	scale.x = START_SCALE
	scale.z = START_SCALE


func _process(delta: float) -> void:
	scale.x -= delta * SHRINK_SPEED
	if scale.x < MIN_SCALE:
		scale.x = MIN_SCALE
	scale.z = scale.x


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("affected by vortex"):
		var timer = preload(VORTEX_TIMER_PATH).instantiate()
		timer.name = TIMER_NAME
		body.add_child(timer)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("affected by vortex"):
		for child in body.get_children():
			if child.name == TIMER_NAME:
				child.queue_free()
				break
