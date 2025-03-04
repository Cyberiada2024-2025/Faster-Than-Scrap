extends Node3D


func _ready() -> void:
	get_parent().body_entered.connect(_find_parent_collision)
	get_parent().contact_monitor = true
	if get_parent().max_contacts_reported <=0:
		get_parent().max_contacts_reported = 10


func _find_parent_collision(body: Node) -> void:
	if body.is_in_group("deal damege by collisions"):
		var damage: int = calculate_damage(get_parent(), body)
		get_parent().take_damage(damage)


# from atribute nodes include:
# 	dealt_damage_multiplier
# 	self_damage_multiplier
func calculate_damage(me: Node, oponent: Node) -> int:
	# calculate base damage
	var direction: Vector3 = me.position.direction_to(oponent.position)
	var base_damage: float = (me.linear_velocity + oponent.linear_velocity).dot(direction)
	base_damage = abs(base_damage)
	# get multiplies
	var self_dmg_mult: float = 1
	if "self_damage_multiplier" in me:
		self_dmg_mult *= me.self_damage_multiplier
	if "dealt_damage_multiplier" in oponent:
		self_dmg_mult *= oponent.dealt_damage_multiplier

	# return result
	var damage: float = base_damage * self_dmg_mult
	if "mass" in oponent:
		damage *= oponent.mass / (me.mass + oponent.mass)

	return (int)(damage)
