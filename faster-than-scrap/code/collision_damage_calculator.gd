extends Node

@export var collision_particles: PackedScene = preload(
	"res://prefabs/vfx/particles/timed_particles/collision.tscn"
)

@export_category("CollisionCalculator")
## Target to which the damage will be dealt
@export var damageable: Damageable
## Primary shape that will be taken into account
@export var shape: CollisionShape3D
## If true, all shapes will be taken into account when
## calculating damage
@export var include_other_shapes: bool = false

@export_group("CollisionModifiers")
@export var flat_damage_reduction: float = 10.0
@export var self_damage_multiplier: float = 1.0
@export var dealt_damage_multiplier: float = 1.0

## Object which will react to collisions
var calculated_body: PhysicsBody3D
var pre_collision_velocity: Vector3


func _ready() -> void:
	# check if parent is PhysicsBody3D, to make it work with module ghosts
	if shape.get_parent_node_3d() is not PhysicsBody3D:
		set_process(false)
		return

	calculated_body = shape.get_parent_node_3d()
	calculated_body.set_meta("collision_damage_calculator", self)

	calculated_body.body_shape_entered.connect(_find_parent_collision)
	calculated_body.contact_monitor = true
	if calculated_body.max_contacts_reported <= 0:
		calculated_body.max_contacts_reported = 10


func _process(_delta: float) -> void:
	pre_collision_velocity = calculated_body.linear_velocity


func _find_parent_collision(
	_body_rid: RID, body: Node, _body_shape_index: int, local_shape_index: int
) -> void:
	if not include_other_shapes and calculated_body.get_child(local_shape_index) != shape:
		return
	var damage: Damage = calculate_damage(calculated_body, body)
	damageable.take_damage(damage, body)

	if collision_particles == null:
		return

	var body_direct_state = PhysicsServer3D.body_get_direct_state(calculated_body.get_rid())
	var contact_count = body_direct_state.get_contact_count()

	var average_position = Vector3.ZERO
	var average_normal = Vector3.ZERO
	for i in range(contact_count):
		average_position += body_direct_state.get_contact_collider_position(i)
		average_normal += body_direct_state.get_contact_local_normal(i)
	average_position /= contact_count
	average_normal /= contact_count

	var particles: Node3D = collision_particles.instantiate()
	particles.global_position = average_position
	get_tree().current_scene.add_child(particles)
	particles.look_at(average_position + average_normal)


func calculate_damage(me: Node, oponent: Node) -> Damage:
	var oponet_calculator: Node
	if oponent.has_meta("collision_damage_calculator"):
		oponet_calculator = oponent.get_meta("collision_damage_calculator")
	else:
		oponet_calculator = null

	# calculate base damage
	var direction: Vector3 = me.position.direction_to(oponent.position)
	var v1: Vector3 = self.pre_collision_velocity
	var v2: Vector3
	if oponet_calculator == null:
		v2 = Vector3(0, 0, 0)
	else:
		v2 = oponet_calculator.pre_collision_velocity
	var base_damage: float = (v1 - v2).dot(direction)

	# get multiplies
	var self_dmg_mult: float = 1
	self_dmg_mult *= self.self_damage_multiplier
	if oponet_calculator != null:
		self_dmg_mult *= oponet_calculator.dealt_damage_multiplier

	# return result
	var damage: Damage = Damage.new(base_damage * self_dmg_mult, Damage.Type.COLLISION)
	if "mass" in oponent:
		damage.value *= oponent.mass / (me.mass + oponent.mass)

	damage.value -= flat_damage_reduction
	if damage.value <= 0:
		damage.value = 0
	print(damage)
	return damage
