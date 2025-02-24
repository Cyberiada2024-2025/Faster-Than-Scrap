class_name WeaponModule

extends Module

@export var weapon: BaseWeapon

## If set to false, tries to shoot only after a key has just been pressed. [br]
## Otherwise, the player may hold the activation key to shoot automatically,
## whenever the conditions, such as cooldown or energy requirement, are met.
@export var allow_auto_fire: bool
@export var recoil_force: float = 0

func _ready() -> void:
	super()
	weapon.recoil.connect(_recoil)
	weapon.ship = ship

func _on_key_press(_delta: float) -> void:
	super(_delta)
	if not allow_auto_fire:
		weapon.try_activate()

func _on_key(_delta: float) -> void:
	super(_delta)
	if allow_auto_fire:
		weapon.try_activate()

func _on_release(_delta: float) -> void:
	super(_delta)
	weapon.try_deactivate()

func _recoil(delta: float) -> void:
	apply_force(weapon.global_basis.z * recoil_force * delta)
	pass
