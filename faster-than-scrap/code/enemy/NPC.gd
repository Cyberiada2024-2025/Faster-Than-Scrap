class_name NPC extends ShipController

@export var speed := 16
@export var rotation_speed := 0.04
@export var weapons: Array[BaseWeapon]

var weapon: BaseWeapon


func _ready() -> void:
	gravity_scale = 0
	linear_damp = 20
	angular_damp = 20
	if weapons.size() > 0:
		weapon = weapons[0]
		for w in weapons:
			w.ship = ship
