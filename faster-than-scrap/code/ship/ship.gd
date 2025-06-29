class_name Ship
extends RigidBody3D

signal destroyed(ship: Ship)
signal damaged(hp_percent: float)

## Base class for player and enemy

@export var energy: float = 100:
	get:
		return energy
	set(value):
		var start_energy = energy
		energy = value
		if energy > max_energy:
			energy = max_energy
		if energy != start_energy:
			_on_energy_change()

@export var max_energy: float = 100:
	get:
		return max_energy
	set(value):
		max_energy = value
		_on_energy_max_change()
		if energy > max_energy:
			energy = max_energy

@export var restore: float = 10

@export var max_hp: float = 10

@export var team = TeamManager.Team.ENEMY

@export var leave_animation: LeavingAnimation

var hp: float = 10
var ship_explosion_prefab = preload(
	"res://prefabs/vfx/particles/timed_particles/big_explosion.tscn"
)


func _ready() -> void:
	hp = max_hp
	GameManager._on_ship_born(self)


func _process(delta: float) -> void:
	energy += restore * delta


## Called when module wants to use the ship's energy [member Ship.energy].
## Returns true when it can afford that amount (and reduces the energy accordingly)
## otherwise returns false and doesn't change the energy amount.
func use_energy(amount: float) -> bool:
	if energy < amount:
		return false
	energy -= amount
	return true


## Called whenever the energy amount changes.
func _on_energy_change() -> void:
	pass


## Called whenever the max energy amount changes.
func _on_energy_max_change() -> void:
	pass


func _on_take_damage(damage: Damage) -> void:
	hp -= damage.value
	damaged.emit(hp / max_hp)
	if hp <= 0:
		on_destroy()


func on_destroy() -> void:
	_explode()
	destroyed.emit(self)
	# if enemy delete yourself, player should be kept
	if not self is PlayerShip:
		owner.queue_free()


func _explode() -> void:
	var explosion: TimedParticle = ship_explosion_prefab.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position


func leave_map() -> void:
	pass
