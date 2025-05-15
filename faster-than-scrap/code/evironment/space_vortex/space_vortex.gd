class_name SpaceVortex
extends Area3D

const VORTEX_PREFAB: PackedScene = preload(
	"res://prefabs/environment/space_vortex/space_vortex.tscn"
)

const DAMAGE: float = 10  # damage per second
const RADIUS: String = "Safe_Radius"
const CENTER: String = "Safe_Center"

@export var graphics: GeometryInstance3D
@export var mat: ShaderMaterial

var damageables_in_vortex: Array[Damageable] = []

# vortex parameters
var start_scale: float = 100
var min_scale: float = 0.001
var shrinking_time: float = 3 * 60  # in seconds

var _shrink_speed: float  # units per seconds


## static spawner of vortex with paramateres deciding its behaviour
static func spawn_vortex(
	start_position: Vector3,
	start_scale: float = 200,
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
	graphics.reparent(GameManager.get_tree().current_scene)
	_shrink_speed = (start_scale - min_scale) / shrinking_time
	scale.x = start_scale
	scale.z = start_scale
	mat.set_shader_parameter(RADIUS, start_scale)


func _process(delta: float) -> void:
	_scale_self(delta)
	_damage_objects(delta)


func _scale_self(delta: float) -> void:
	scale.x -= delta * _shrink_speed
	if scale.x < min_scale:
		scale.x = min_scale
	scale.z = scale.x
	mat.set_shader_parameter(RADIUS, scale.x)


func _damage_objects(delta: float) -> void:
	# iterate over list backwards to allow removing elements
	for i in range(damageables_in_vortex.size() - 1, -1, -1):
		var damageable = damageables_in_vortex[i]
		if not is_instance_valid(damageable):
			damageables_in_vortex.remove_at(i)
			continue
		damageable.take_damage(Damage.new(DAMAGE * delta), self)


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("affected by vortex"):
		damageables_in_vortex.append(body)


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("affected by vortex"):
		damageables_in_vortex.erase(body)
