class_name WeaponModule

extends Module

@export var weapon: BaseWeapon

## If set to false, tries to shoot only after a key has just been pressed. [br]
## Otherwise, the player may hold the activation key to shoot automatically,
## whenever the conditions, such as cooldown or energy requirement, are met.
@export var allow_auto_fire: bool


func _ready() -> void:
	super()
	weapon.recoil.connect(_recoil)
	weapon.ship = ship


func _on_key_press(_delta: float) -> void:
	super(_delta)
	if not allow_auto_fire:
		var result = weapon.try_activate()
		if result != []:
			activated.emit()


func _on_key(_delta: float) -> void:
	super(_delta)
	if allow_auto_fire:
		var result = weapon.try_activate()
		if result != []:
			activated.emit()


func _on_release(_delta: float) -> void:
	super(_delta)
	var result = weapon.try_deactivate()
	if result != false:
		deactivated.emit()


func _recoil(force_multiplier: float) -> void:
	if DebugMenu.enable_debug_movement:
		return

	ship.apply_force(
		weapon.global_basis.z * force_multiplier, global_position - ship.global_position
	)


func set_ship_reference(ship_ref: Ship) -> void:
	super(ship_ref)
	weapon.ship = ship_ref


func deactivate() -> void:
	super()
	weapon.force_deactivate()
