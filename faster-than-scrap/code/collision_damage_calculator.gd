extends Node

@export_category("ColisionCalculator")
## Target to which the damage will be dealt
@export var damageable: Damageable
## Primary shape that will be taken into account
@export var shape: CollisionShape3D
## If true, all shapes will be taken into account when
## calculating damage
@export var include_other_shapes: bool = false

@export_group("ColisionModifiers")
@export var flat_damage_reduction: float = 10.0
@export var self_damage_multiplier: float = 1.0
@export var dealt_damage_multiplier: float = 1.0

## Object which will react to collisions
var calculated_body: PhysicsBody3D
var pre_collision_velosity: Vector3


func _ready() -> void:
	# check if parent is PB, to make it work with module ghosts
	if shape.get_parent_node_3d() is not PhysicsBody3D:
		# destroy self, cause you are in ghost
		queue_free()
	else:
		calculated_body = shape.get_parent_node_3d()
		calculated_body.set_meta("collision_damage_calculator", self)

		calculated_body.body_shape_entered.connect(_find_parent_collision)
		calculated_body.contact_monitor = true
		if calculated_body.max_contacts_reported <= 0:
			calculated_body.max_contacts_reported = 10


func _process(_delta: float) -> void:
	pre_collision_velosity = calculated_body.linear_velocity


func _find_parent_collision(
	_body_rid: RID, body: Node, _body_shape_index: int, local_shape_index: int
) -> void:
	if not include_other_shapes and calculated_body.get_child(local_shape_index) != shape:
		return
	var damage: Damage = calculate_damage(calculated_body, body)
	damageable.take_damage(damage, body)


func calculate_damage(me: Node, oponent: Node) -> Damage:
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
	var damage: Damage = Damage.new(base_damage * self_dmg_mult)
	if "mass" in oponent:
		damage.value *= oponent.mass / (me.mass + oponent.mass)

	damage.value -= flat_damage_reduction
	if damage.value <= 0:
		damage.value = 0
	print(damage)
	return damage
