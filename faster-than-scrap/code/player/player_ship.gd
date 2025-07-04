class_name PlayerShip

extends Ship

## Extension of Ship class.
## Supposed to be used only by player.

signal energy_change(energy: float)
signal energy_max_change(max_energy: float)
signal energy_warning(energy: float)

signal fuel_change(new_value: int)

@export var linear_damp_value := 0.4
@export var angular_damp_value := 1.5

@export var cockpit: Cockpit
@export var debug_movement_force: float = 20

## All modules of the ship (to prevent checking the tree hierarchy).
## Mostly used for building phase
var modules: Array[Module] = []
var money: int = 0
var current_fuel: int = 0:
	get:
		return current_fuel
	set(new_value):
		var temp = current_fuel
		current_fuel = new_value
		if temp != current_fuel:
			fuel_change.emit(current_fuel)

var _saved_position: Vector3 = Vector3.ZERO
var _saved_rotation: Vector3 = Vector3.ZERO


func _enter_tree() -> void:
	GameManager.player_ship = self
	center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM


func _ready() -> void:
	super()
	change_air_resistance()
	change_cockpit_icon()
	for child in get_children():
		if child is Module:
			modules.append(child)

	if DebugMenu.is_debug:
		DebugMenu.toggle_player_collisions.connect(_toggle_collisions)

		if DebugMenu.disable_collisions:
			_toggle_collisions()

	energy_max_change.emit(max_energy)
	_on_energy_change()

	update_mass()


func _process(_delta: float) -> void:
	super(_delta)
	$CenterOfMass.position = center_of_mass
	# move it down so it won't fiddle with modules (in shop)
	var children_count = get_children().size()
	move_child($CenterOfMass, children_count - 1)


func update_mass() -> void:
	var center = Vector3(0, 1, 0)
	var total_mass = 0
	# avoid division by zero
	if modules.size() == 0:
		return

	for mod in modules:
		center += mod.position * mod.mass
		total_mass += mod.mass
	center /= total_mass
	mass = total_mass
	center_of_mass = center


func _physics_process(_delta: float) -> void:
	if not DebugMenu.enable_debug_movement:
		return

	var input_direction = Input.get_vector(
		"debug_move_left", "debug_move_right", "debug_move_up", "debug_move_down"
	)

	var force_direction = Vector3(
		input_direction.x,
		0,
		input_direction.y,
	)

	apply_force(force_direction * debug_movement_force * mass)


func change_air_resistance() -> void:
	if SettingsManager.air_resistance:
		linear_damp = linear_damp_value
		angular_damp = angular_damp_value
	else:
		linear_damp = 0
		angular_damp = 0


func change_cockpit_icon() -> void:
	if SettingsManager.brakes_enabled:
		cockpit.cockpit_sprite.texture = cockpit.default_texture
		cockpit.cockpit_label.visible = true
	else:
		cockpit.cockpit_sprite.texture = cockpit.cockpit_texture
		cockpit.cockpit_label.visible = false


func save_position():
	_saved_position = position


func save_rotation():
	_saved_rotation = rotation


func get_saved_position():
	return _saved_position


func get_saved_rotation():
	return _saved_rotation


## Called whenever the energy amount changes.
func _on_energy_change() -> void:
	super()
	energy_change.emit(energy)


## Called whenever the max energy amount changes.
func _on_energy_max_change() -> void:
	super()
	energy_max_change.emit(max_energy)


func use_energy(amount: float) -> bool:
	if energy < amount:
		energy_warning.emit()
	return super(amount)


func on_destroy() -> void:
	super()
	GameManager.show_death_screen()


func _shoud_be_freed() -> bool:
	return false


func _toggle_collisions() -> void:
	for child in get_children():
		if child is CollisionShape3D:
			child.disabled = not child.disabled
