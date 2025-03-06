class_name Shooting

extends StateNPC

@export var weapons: Array[BaseWeapon]



func state_update(_delta: float) -> void:
	_shoot_all_weapons()

## try to shoot all weapons if possible
func _shoot_all_weapons() -> void:
	for weapon in weapons:
		weapon.try_activate()
