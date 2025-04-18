class_name DamageRaycast3D

extends RayCast3D

## RayCast3D which damages the [Damageable] node hit by it. [br]
## For area collisions (e.g. engine exhaust), use [DamageArea3D].

## Signal emitted everytime this node applies damage to a [Damageable] node.
signal damage_applied(damage: Damage, target: Damageable)

## If set to [code]false[/code], this node will be destroyed immediately after applying damage. [br]
## If set to [code]true[/code], the damage will be applied constantly.
@export var _constant_fire: bool = true

## How much damage does the ray deal to [Damageable] nodes.
## If [member _constant_fire] is set to [code]true[/code], specifies damage per second.
@export var _damage: Damage

## Default Raycast3D properties will be overriden by properties defined here. [br]
## This is needed because it's otherwise impossible to change the defaults in the extending class.
@export_group("Raycast3D Overrides")
@export_subgroup("Collide With")
@export var _areas = true
@export var _bodies = false


func _ready():
	collide_with_areas = _areas
	collide_with_bodies = _bodies


func _process(delta):
	var collider = get_collider()
	if collider != null and collider is Damageable:
		var actual_damage = _damage if not _constant_fire else _damage.multiply(delta)
		_apply_damage(actual_damage, collider)


func _apply_damage(damage: Damage, target: Damageable) -> void:
	target.take_damage(damage, self)
	damage_applied.emit(damage, target)
	if not _constant_fire:
		queue_free()
