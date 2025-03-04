class_name Beam

extends Node3D

## Beam object that extends from it's start position up to the [DamageRaycast3D] beam length,
## or the raycast's collision point.

@onready var _damage_raycast: DamageRaycast3D = $DamageRaycast3D

## Node that will be scaled so that it's Z size is the same as the beam's length.
@export var beam_indicator: Node3D

## If true, the beam will die immediately after hitting something.
## Otherwise it will keep going until it is destroyed by other means. [br]
## Note: In both cases, die_on_hit in the child [DamageRaycast3D] should be set to false.
@export var die_on_hit: bool = false

var _beam_length: float


func _ready() -> void:
	_beam_length = _damage_raycast.target_position.length()
	_damage_raycast.damage_applied.connect(_on_damage_applied)


func _process(delta: float) -> void:
	if _damage_raycast.is_colliding():
		var ray_length = _damage_raycast.position.distance_to(_damage_raycast.get_collision_point())
		beam_indicator.scale.z = ray_length
	else:
		beam_indicator.scale.z = _beam_length


func _on_damage_applied(_damage: Damage, _target: Damageable):
	if die_on_hit:
		queue_free()
