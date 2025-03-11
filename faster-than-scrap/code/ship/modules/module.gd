class_name Module

extends CollisionShape3D

## Base class for all modules
## The object should have scale 1 to work properly!

@export var activation_key: Key = KEY_NONE
@export var max_hp: float = 100
@export var hp: float = 100
@export var ship: Ship
@export var attach_points: Array[Node3D] = []
@export var parent_module: Module
@export var child_modules: Array[Module] = []

@export var sprite: Sprite3D
@export var label: Label3D

@export var healthy_color: Color
@export var dead_color: Color

var was_key_pressed: bool = false

var module_rigidbody_prefab = preload("res://prefabs/modules/module_rigidbody.tscn")


func _ready() -> void:
	on_key_change(activation_key)
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


func update_sprite() -> void:
	if sprite != null:
		sprite.modulate = lerp(dead_color, healthy_color, hp / max_hp)


## Destroy self and detach children
func _on_destroy() -> void:
	if parent_module != null:
		parent_module.child_modules.erase(self)
	_explode()
	for child in child_modules:
		var rb: RigidBody3D = module_rigidbody_prefab.instantiate()
		var root = get_tree().get_root()
		get_tree().get_root().add_child(rb)  # attach to scene root
		child.reparent(rb)
		rb.linear_velocity = ship.linear_velocity
		child.deactivate()
	queue_free()  # delete self as an object


func deactivate() -> void:
	activation_key = 0
	for child in child_modules:
		child.deactivate()


func _explode() -> void:
	# TODO create particles object,
	# which will die after some die by itself
	pass


func detachable() -> bool:
	return true


func on_key_change(key: Key) -> void:
	activation_key = key
	var text: String = OS.get_keycode_string(activation_key)
	if label != null:
		label.text = text
		## one line text up to 3 characters
		if text.length() <= 0:
			return
		if text.length() <= 3:
			label.font_size = 160 / text.length()
		else:
			label.font_size = 160 / text.length() * 2


func has_child_module() -> bool:
	return child_modules.size() > 0


func set_ship_reference(ship: Ship) -> void:
	self.ship = ship


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
func create_ghost() -> Area3D:
	var ghost := Area3D.new()
	for child in get_children():
		var child_copy = child.duplicate()
		ghost.add_child(child_copy)
	get_tree().root.add_child(ghost)
	return ghost
