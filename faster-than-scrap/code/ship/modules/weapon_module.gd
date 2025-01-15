class_name WeaponModule

extends Module


@export var cooldown: float
@export var energy_cost: float
@export var recoil_force: float

@export var allow_auto_fire: bool
@export var constant_fire: bool

@export var projectile: PackedScene

# todo: draw an arrow in the editor to mark the position and rotation
@export var muzzle_position: Vector2
@export var muzzle_rotation: float


var current_cooldown: float = 0
var active_projectile: Projectile = null


func _process(delta: float) -> void:
	super(delta)
	if current_cooldown > 0:
		current_cooldown -= delta

func _on_key_press(_delta: float) -> void:
	super(_delta)
	if not allow_auto_fire:
		try_shoot()


func _on_key(_delta: float) -> void:
	super(_delta)
	if allow_auto_fire:
		try_shoot()


func _on_release(_delta: float) -> void:
	super(_delta)

	if constant_fire and active_projectile != null:
		_despawn_projectile()


## Tries to shoot. Returns whether or not it succeeded. [br]
## [method WeaponModule.try_shoot] can fail if the owner doesn't have enough energy
## or if the cooldown time hasn't yet passed.
func try_shoot() -> bool:
	if current_cooldown > 0:
		return false
	if ship.energy < energy_cost:
		return false

	current_cooldown = cooldown
	ship.energy -= energy_cost
	# todo: add recoil to ship in the

	if not constant_fire:
		_spawn_projectile()
		return true

	if active_projectile == null:
		_spawn_projectile()
		return true

	return false


func _spawn_projectile() -> void:
	var new_projectile = projectile.instantiate()

	new_projectile.position = Vector3(
		position.x + muzzle_position.x,
		position.y,
		position.z + muzzle_position.y,
	)
	new_projectile.rotation_degrees = Vector3(
		rotation_degrees.x,
		rotation_degrees.y + muzzle_rotation,
		rotation_degrees.z,
	)

	get_tree().get_root().add_child(new_projectile)

	print(new_projectile.position)
	print(new_projectile.rotation_degrees)

	if constant_fire:
		active_projectile = new_projectile


func _despawn_projectile() -> void:
	active_projectile.queue_free()
