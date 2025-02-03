class_name ShieldModule

extends Module

@export var energy_per_turning: float
@export var energy_per_sec: float
@export var energy_per_dmg: float
@export var shield: Shield
@export var collider: CollisionShape3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(shield.on && !ship.use_energy(delta * energy_per_sec)):
		shield.turn_on_off()
	super._process(delta)
		
func take_shield_damage(dmg: int) -> void:
	if(shield.on && !ship.use_energy(dmg * energy_per_dmg)):
		shield.turn_on_off()
		ship.use_energy(ship.energy - 1)
	elif(shield.on):
		shield.take_damage()
		
func _on_key_press(_delta: float) -> void:
	if(shield.on):
		shield.turn_on_off()
	elif(ship.use_energy(energy_per_turning)):
		shield.turn_on_off()
