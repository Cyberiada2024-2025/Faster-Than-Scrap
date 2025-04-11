class_name NPC extends ShipController

@export var speed := 16
@export var rotation_speed := 0.04
@export var weapon: BaseWeapon


func _ready() -> void:
	if weapon != null:
		weapon.ship = ship
