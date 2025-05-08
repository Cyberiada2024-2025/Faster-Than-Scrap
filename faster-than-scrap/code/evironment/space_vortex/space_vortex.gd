class_name SpaceVortex
extends Area3D

const VORTEX_PREFAB: PackedScene = preload(
	"res://prefabs/environment/space_vortex/space_vortex.tscn"
)
const VORTEX_TIMER_PATH: String = "res://prefabs/environment/space_vortex/inside_vortex_timer.tscn"
const TIMER_NAME: String = "VortexTimer926452"

var start_scale: float = 400
var min_scale: float = 0.001
var shrinking_time: float = 3 * 60  # in seconds
var shrink_speed: float  # units per seconds


static func spawn_vortex(
	start_position: Vector3,
	start_scale: float = 400,
	min_scale: float = 0.001,
	shrinking_time: float = 3 * 60
) -> void:
	var vortex = VORTEX_PREFAB.instantiate()

	vortex.position = start_position
	vortex.start_scale = start_scale
	vortex.min_scale = min_scale
	vortex.shrinking_time = shrinking_time

	GameManager.get_tree().current_scene.add_child.call_deferred(vortex)


func _ready() -> void:
	shrink_speed = (start_scale - min_scale) / shrinking_time
	scale.x = start_scale
	scale.z = start_scale


func _process(delta: float) -> void:
	scale.x -= delta * shrink_speed
	if scale.x < min_scale:
		scale.x = min_scale
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
