extends Node

@export_category("ColisionCalculator")
@export var calculated_body: PhysicsBody3D
@export_group("ColisionModifiers")
@export var flat_damage_reduction: float = 10.0
@export var self_damage_multiplier: float = 1.0
@export var dealt_damage_multiplier: float = 1.0

var pre_collision_velosity: Vector3


func _ready() -> void:
	calculated_body.set_meta("collision_damage_calculator", self)

	calculated_body.body_entered.connect(_find_parent_collision)
	calculated_body.contact_monitor = true
	if calculated_body.max_contacts_reported <= 0:
		calculated_body.max_contacts_reported = 10


func _process(_delta: float) -> void:
	pre_collision_velosity = calculated_body.linear_velocity


func _find_parent_collision(body: Node) -> void:
	var damage: float = calculate_damage(calculated_body, body)
	calculated_body.take_damage(damage)


func calculate_damage(me: Node, oponent: Node) -> float:
	var oponet_calculator: Node
	if oponent.has_meta("collision_damage_calculator"):
		oponet_calculator = oponent.get_meta("collision_damage_calculator")
	else:
		oponet_calculator = null

	# calculate base damage
	var direction: Vector3 = me.position.direction_to(oponent.position)
	var v1: Vector3 = self.pre_collision_velosity
	var v2: Vector3
	if oponet_calculator == null:
		v2 = Vector3(0, 0, 0)
	else:
		v2 = oponet_calculator.pre_collision_velosity
	var base_damage: float = (v1 - v2).dot(direction)

	# get multiplies
	var self_dmg_mult: float = 1
	self_dmg_mult *= self.self_damage_multiplier
	if oponet_calculator != null:
		self_dmg_mult *= oponet_calculator.dealt_damage_multiplier

	# return result
	var damage: float = base_damage * self_dmg_mult
	if "mass" in oponent:
		damage *= oponent.mass / (me.mass + oponent.mass)

	damage -= flat_damage_reduction
	if damage <= 0:
		damage = 0
	print(damage)
	return damage
