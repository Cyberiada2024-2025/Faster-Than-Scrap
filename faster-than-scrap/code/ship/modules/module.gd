class_name Module

extends CollisionShape3D

## Base class for all modules
## The object should have scale 1 to work properly!

signal activated
signal deactivated
signal damaged
signal destroyed

const EXPLOSION_MAX_RANDOM_SPEED = 2
const EXPLOSION_MAX_RANDOM_ROTATION = 1

const EXPLOSION_SPEED_MULTIPLIER = 1
const EXPLOSION_DISTANCE_EXPONENT = 1

@export_category("Settings")
@export var activation_key: Key = KEY_NONE
@export var is_activable: bool = true
@export var max_hp: float = 100
@export var hp: float = 100
@export_category("References")
@export var ship: Ship
@export var attach_points: Array[Node3D] = []
@export var parent_module: Module
@export var child_modules: Array[Module] = []
@export_category("Graphics")
@export var sprite: Sprite3D
@export var label: Label3D

@export var healthy_color: Color
@export var dead_color: Color

@export_category("Shop")
## Prize in shop
@export var module_name: String
@export_custom(PROPERTY_HINT_NONE, "suffix:$") var prize: int = 1
@export_multiline var description: String

var reserved_keys: Array[Key] = [KEY_ENTER, KEY_ESCAPE]

var was_key_pressed: bool = false

var module_rigidbody_prefab = preload("res://prefabs/modules/module_rigidbody.tscn")

var activation_key_saved: Key = KEY_NONE

var module_explosion_prefab = preload(
	"res://prefabs/vfx/particles/timed_particles/module_explosion.tscn"
)


func keycode_from_input_map(event_name: String) -> Key:
	return (InputMap.action_get_events(event_name)[0] as InputEventKey) \
			.get_physical_keycode_with_modifiers()


func reserve_keys_from_actions(actions: Array[String]):
	for action in actions:
		reserved_keys.append(keycode_from_input_map(action))


func reserve_keys():
	if OS.is_debug_build():
		reserve_keys_from_actions(["debug_menu"])

	reserve_keys_from_actions([
		"pause_menu",
		"Skip Cutscene"
	])


func _ready() -> void:
	reserve_keys()
	activation_key_saved = activation_key
	_on_key_change()
	update_sprite()


func _process(_delta: float) -> void:
	if was_key_pressed:
		if Input.is_key_pressed(activation_key):
			_on_key(_delta)
		else:
			was_key_pressed = false
			_on_release(_delta)
	else:
		if Input.is_key_pressed(activation_key):
			_on_key_press(_delta)
			_on_key(_delta)
			was_key_pressed = true

	if label != null:
		label.rotation.y = -global_rotation.y


# virtual functions


## Called on one frame, when [member Module.activation_key] has just been pressed
func _on_key_press(_delta: float) -> void:
	pass


## Called on every frame when [member Module.activation_key] is pressed
func _on_key(_delta: float) -> void:
	pass


## Called on one frame, when [member Module.activation_key] has just been released
func _on_release(_delta: float) -> void:
	pass


func take_damage(damage: Damage) -> void:
	hp -= damage.value
	update_sprite()
	if hp <= 0:
		_on_destroy()
	damaged.emit()


func heal(value: float) -> void:
	hp += value
	hp = min(hp, max_hp)
	update_sprite()


func update_sprite() -> void:
	if sprite != null:
		sprite.modulate = lerp(dead_color, healthy_color, hp / max_hp)


## Destroy self and detach children
func _on_destroy() -> void:
	if parent_module != null:
		parent_module.child_modules.erase(self)
	_explode()

	detach_all_children(global_position)

	if parent_module != null:
		on_detach()

	queue_free()  # delete self as an object
	destroyed.emit()


func detach_all_children(explosion_center: Vector3) -> void:
	for child in child_modules:
		var rb: RigidBody3D = module_rigidbody_prefab.instantiate()
		get_tree().current_scene.add_child(rb)  # attach floating modules to scene
		child.reparent(rb)
		rb.linear_velocity = ship.linear_velocity

		rb.linear_velocity += Vector3(
			randf_range(-EXPLOSION_MAX_RANDOM_SPEED, EXPLOSION_MAX_RANDOM_SPEED),
			0,
			randf_range(-EXPLOSION_MAX_RANDOM_SPEED, EXPLOSION_MAX_RANDOM_SPEED)
		)

		rb.linear_velocity += (
			explosion_center.direction_to(child.global_position)
			* pow(explosion_center.distance_to(child.global_position), EXPLOSION_DISTANCE_EXPONENT)
			* EXPLOSION_SPEED_MULTIPLIER
		)

		rb.angular_velocity = Vector3(
			randf_range(-EXPLOSION_MAX_RANDOM_ROTATION, EXPLOSION_MAX_RANDOM_ROTATION),
			randf_range(-EXPLOSION_MAX_RANDOM_ROTATION, EXPLOSION_MAX_RANDOM_ROTATION),
			randf_range(-EXPLOSION_MAX_RANDOM_ROTATION, EXPLOSION_MAX_RANDOM_ROTATION)
		)

		child.deactivate()
		child.on_detach()

		child.detach_all_children(explosion_center)


## Called when the module is attached to the ship
func on_attach() -> void:
	pass


## Called just before the module is detached from the ship
func on_detach() -> void:
	pass


## Called when the module is attached to a different part of the ship than it previously was
func on_reattach() -> void:
	pass


func deactivate() -> void:
	activation_key_saved = activation_key
	activation_key = KEY_NONE


func activate() -> void:
	activation_key = activation_key_saved


func _explode() -> void:
	# create particles object
	var explosion: TimedParticle = module_explosion_prefab.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position


func detachable() -> bool:
	return true


func change_key(key: Key) -> void:
	if activation_key == 0:
		activation_key_saved = key
	else:
		activation_key = key
	_on_key_change()


func _on_key_change() -> void:
	var text: String = OS.get_keycode_string(activation_key_saved)
	if label != null:
		label.text = text
		## one line text up to 3 characters
		if text.length() <= 0:
			return
		if text.length() <= 3:
			label.font_size = int(160.0 / text.length())
		else:
			label.font_size = int(160.0 / text.length() * 2)


func has_child_module() -> bool:
	return child_modules.size() > 0


func set_ship_reference(ship_ref: Ship) -> void:
	ship = ship_ref


## Returns the node3D which is the center of the attach point.
## Foward vector of that returned node indicates the forward rotation of the module
## when attached to that point
func get_attach_point(index: int) -> Node3D:
	if attach_points.size() == 0:
		printerr("MODULE HAS NO ATTACH POINTS")
	return attach_points[index % attach_points.size()]


## Create an Area3D object which is a copy of module tree
## with the only difference of a root not being a module (rigidbody3d).
## All children are copied!
func create_ghost() -> ModuleGhost:
	# create ghost in scene
	var ghost := ModuleGhost.new()
	get_tree().root.add_child(ghost)
	ghost.name = "ghost"
	ghost.global_position = global_position

	# duplicate module
	var duplicate_node: Node3D = self.duplicate()
	ghost.add_child(duplicate_node)
	duplicate_node.position = Vector3.ZERO
	duplicate_node.rotation = Vector3.ZERO
	duplicate_node.prize = 0
	ghost.module_to_ignore = self

	return ghost


## Return all children (even indirect) modules of a given node.
static func find_all_modules(node: Node) -> Array[Module]:
	var result = []
	for child in node.get_children():
		if child is Module:
			result.append(child)
		result.append_array(find_all_modules(child))  # Recurse
	var modules: Array[Module] = []
	modules.assign(result)	# create module typed array
	return modules
