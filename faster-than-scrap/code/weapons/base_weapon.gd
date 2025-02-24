class_name BaseWeapon

extends Node3D

## Base class for all weapons.

signal recoil

@export var ship: Ship

@export var energy_cost: float
@export var cooldown: float
@export var recoil_force: float

## Prefab of the projectile that will be spawned when shooting. Must be of type [class Projectile].
@export var projectile: PackedScene

var _current_cooldown: float = 0


func _process(delta: float) -> void:
	if _current_cooldown > 0:
		_current_cooldown -= delta

## Returns whether or not the weapon can be activated.
## Takes into account [member Ship.energy] and the current [member cooldown]
func can_activate() -> bool:
	if _current_cooldown > 0 or ship.energy < energy_cost:
		return false
	return true

## Tries to activate the weapon.
## Returns the spawned [class Projectile] if it succeded and [code]null[/code] otherwise
func try_activate() -> Projectile:
	return null

## Tries to deactivate the weapon.
## Returns whether or not it succeeded. [br]
## Only some weapons require deactivation.
func try_deactivate() -> bool:
	return false

func _spawn_projectile() -> Projectile:
	return projectile.instantiate()
