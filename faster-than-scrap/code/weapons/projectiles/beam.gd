class_name Beam

extends Node3D

const start_anim: String = "On"
const end_anim: String = "Off"

## Beam object that extends from it's start position up to the [DamageRaycast3D] beam length,
## or the raycast's collision point.

## Node that will be scaled so that it's Z size is the same as the beam's length.
@export var beam_indicator: Node3D
@export var max_length: float = 20

@export var player: AnimationPlayer
@export var holder: WaitFree

@export var mesh: MeshInstance3D
@export var length_name: String = "current_length"

var animation_check: bool
var _beam_length: float

@onready var _damage_raycast: DamageRaycast3D = $DamageRaycast3D


func _ready() -> void:
	animation_check = player.has_animation(start_anim) && player.has_animation(end_anim)
	if animation_check:
		player.play(start_anim)
	_damage_raycast.target_position = Vector3.FORWARD * max_length
	_beam_length = _damage_raycast.target_position.length()


func _process(_delta: float) -> void:
	if _damage_raycast.is_colliding():
		var ray_length = _damage_raycast.global_position.distance_to(
			_damage_raycast.get_collision_point()
		)
		beam_indicator.scale.z = ray_length
		if mesh != null:
			mesh.material_override.set_shader_parameter(length_name, ray_length)
	else:
		beam_indicator.scale.z = _beam_length
		if mesh != null:
			mesh.material_override.set_shader_parameter(length_name, _beam_length)

func _notification(notification):
	if (notification == NOTIFICATION_PREDELETE):
		holder.reparent(get_parent())
		if animation_check:
			player.play(end_anim)
		holder.wait_free()
