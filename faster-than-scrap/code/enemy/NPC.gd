class_name NPC extends ShipController

@export var speed := 16
@export var rotation_speed := 0.04
@export var weapons: Array[BaseWeapon]

var weapon: BaseWeapon


func _ready() -> void:
	axis_lock_linear_y = true
	axis_lock_angular_x = true
	axis_lock_angular_z = true
	if weapons.size() > 0:
		weapon = weapons[0]
		for w in weapons:
			w.ship = ship
