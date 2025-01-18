class_name BaseWeapon

extends Node3D

## Base class for all weapons.

@export var ship: Ship

@export var energy_cost: float
@export var cooldown: float
@export var recoil_force: float

@export var projectile: PackedScene

var current_cooldown: float = 0


func _process(delta: float) -> void:
	if current_cooldown > 0:
		current_cooldown -= delta


func can_activate() -> bool:
	if current_cooldown > 0 or ship.energy < energy_cost:
		return false
	return true


func try_activate() -> Projectile:
	return null


func try_deactivate() -> bool:
	return false


func _spawn_projectile() -> Projectile:
	return projectile.instantiate()
