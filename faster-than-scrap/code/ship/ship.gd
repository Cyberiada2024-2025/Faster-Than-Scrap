class_name Ship
extends Node3D

signal destroyed

## Base class for player and enemy

@export var energy: float = 100

@export var max_energy: float = 100

@export var restore: float = 10

@export var max_hp: float = 10

@export var leave_animation: LeavingAnimation

var hp: float = 10
var ship_explosion_prefab = preload(
	"res://prefabs/vfx/particles/timed_particles/big_explosion.tscn"
)


func _ready() -> void:
	hp = max_hp


func _process(delta: float) -> void:
	energy += restore * delta
	if energy > max_energy:
		energy = max_energy


## Called when module wants to use the ship's energy [member Ship.energy].
## Returns true when it can afford that amount (and reduces the energy accordingly)
## otherwise returns false and doesn't change the energy amount.
func use_energy(amount: float) -> bool:
	if energy < amount:
		return false
	energy -= amount
	_on_energy_change()
	return true


## Called whenever the energy amount changes.
func _on_energy_change() -> void:
	pass


func _on_take_damage(damage: Damage) -> void:
	hp -= damage.value
	if hp <= 0:
		on_destroy()


func on_destroy() -> void:
	destroyed.emit()
	_explode()
	owner.queue_free()


func _explode() -> void:
	var explosion: TimedParticle = ship_explosion_prefab.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position


func leave_map() -> void:
	pass
