class_name Beam

extends Node3D

## Beam object that extends from it's start position up to the [DamageRaycast3D] beam length,
## or the raycast's collision point.

## Node that will be scaled so that it's Z size is the same as the beam's length.
@export var beam_indicator: Node3D

var _beam_length: float
var _was_colliding: bool = false
var _beam_particles: Node3D

@onready var _damage_raycast: DamageRaycast3D = $DamageRaycast3D


func _ready() -> void:
	_beam_length = _damage_raycast.target_position.length()
	_beam_particles = preload("res://prefabs/vfx/particles/beam_particles.tscn").instantiate()
	self.add_child(_beam_particles)


func _process(_delta: float) -> void:
	if _damage_raycast.is_colliding():
		var ray_length = _damage_raycast.global_position.distance_to(
			_damage_raycast.get_collision_point()
		)
		beam_indicator.scale.z = ray_length
		_beam_particles.global_position = _damage_raycast.get_collision_point()
		_beam_particles.look_at(_damage_raycast.global_position)
		if not _was_colliding:
			_was_colliding = true
			_beam_particles.visible = true
	else:
		beam_indicator.scale.z = _beam_length
		if _was_colliding:
			_was_colliding = false
			_beam_particles.visible = false
