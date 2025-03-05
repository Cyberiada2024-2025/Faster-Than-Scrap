class_name Beam

extends Node3D

## Beam object that extends from it's start position up to the [DamageRaycast3D] beam length,
## or the raycast's collision point.

## Node that will be scaled so that it's Z size is the same as the beam's length.
@export var beam_indicator: Node3D

var _beam_length: float

@onready var _damage_raycast: DamageRaycast3D = $DamageRaycast3D


func _ready() -> void:
	_beam_length = _damage_raycast.target_position.length()


func _process(_delta: float) -> void:
	if _damage_raycast.is_colliding():
		var ray_length = _damage_raycast.position.distance_to(_damage_raycast.get_collision_point())
		beam_indicator.scale.z = ray_length
	else:
		beam_indicator.scale.z = _beam_length
