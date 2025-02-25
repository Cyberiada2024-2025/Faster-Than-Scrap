class_name Damageable

extends Area3D

## Represents a damageable object, or a part of such object.

## Signal emitted when the object takes damage.
## (i.e. when [method Damageable.take_damage] is called.)
signal damaged(damage: Damage, source: Node)

## The damage taken is multiplied by this value when the object takes damage. [br]
## Should be equal to [code]1[/code] in most cases, but can be used to implement weak points, etc.
@export var _damage_multiplier: float = 1

## Method that should be called by the damaging object when [Damageable] gets damaged.
## Emits the [signal damaged] signal. [br]
## [code]damage[/code] is the damage amount, and [code]source[/code] is the damaging object.
func take_damage(damage: Damage, source: Node):
	damaged.emit(damage.multiply(_damage_multiplier), source)
