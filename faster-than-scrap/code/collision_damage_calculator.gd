extends Node3D


# return Dictionary:
# 	"self_damage" - damage dealt to yourself
# 	"dealt_damage" - damage dealt to oponent
# from atribute nodes include:
# 	dealt_damage_multiplier
# 	self_damage_multiplier
func calculate_damage(me: Node, oponent: Node) -> Dictionary:
	# calculate base damage
	var direction: Vector3 = me.position.direction_to(oponent.position)
	var base_damage: int = (me.linear_velocity + oponent.linear_velocity).dot(direction)
	base_damage = abs(base_damage)
	base_damage = me.mass * oponent.mass * base_damage

	# get multiplies
	var dealt_dmg_mult: float = 1
	if "dealt_damage_multiplier" in me:
		dealt_dmg_mult *= me.dealt_damage_multiplier
	if "self_damage_multiplier" in oponent:
		dealt_dmg_mult *= oponent.self_damage_multiplier

	var self_dmg_mult: float = 1
	if "self_damage_multiplier" in me:
		self_dmg_mult *= me.self_damage_multiplier
	if "dealt_damage_multiplier" in oponent:
		self_dmg_mult *= oponent.dealt_damage_multiplier

	# pack results
	var result: Dictionary
	result["dealt_damage"] = base_damage * dealt_dmg_mult
	result["self_damage"] = base_damage * self_dmg_mult
	return result
