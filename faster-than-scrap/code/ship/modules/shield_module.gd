class_name ShieldModule

extends Module

signal shield_damaged
signal shield_broken

@export var energy_per_turning: float
@export var energy_per_sec: float
@export var energy_per_dmg: float
@export var shield: Shield
@export var collider: CollisionShape3D


func _process(delta: float) -> void:
	if shield.on && !ship.use_energy(delta * energy_per_sec):
		shield.deactivate()
		deactivated.emit()
	super._process(delta)


func take_shield_damage(dmg: Damage) -> void:
	if shield.on && !ship.use_energy(dmg.value * energy_per_dmg):
		shield.deactivate()
		ship.use_energy(ship.energy - 1)
		shield_broken.emit()
	elif shield.on:
		shield.take_damage()
		shield_damaged.emit()


func _on_key_press(_delta: float) -> void:
	if shield.on:
		shield.deactivate()
		deactivated.emit()
	elif ship.use_energy(energy_per_turning):
		shield.activate()
		activated.emit()
