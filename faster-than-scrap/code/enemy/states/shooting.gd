class_name Shooting

extends StateNPC

@export var weapons: Array[BaseWeapon]


func state_update(_delta: float) -> void:
	_shoot_all_weapons()


## try to shoot all weapons if possible
func _shoot_all_weapons() -> void:
	var index: int = 0
	for weapon in weapons:
		if weapon != null:
			weapon.try_activate()
		else:
			weapons.remove_at(index)
		index += 1


func exit() -> void:
	_deactivate_weapons()


## try to deactivate all weapons if possible
func _deactivate_weapons() -> void:
	var index: int = 0
	for weapon in weapons:
		if weapon != null:
			weapon.try_deactivate()
		else:
			weapons.remove_at(index)
		index += 1
