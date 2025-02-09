class_name DamageArea3D

extends Area3D

## Area3D which damages all [Damageable] objects that are in it. [br]
## Should mostly be used for actual area collisions.
## For other collisions (e.g. projectiles), use raycasts.

enum _damage_type_enum {ON_ENTER, ON_STAY, ON_EXIT}

@export var _damage_type: _damage_type_enum
@export var _damage: float

var _colliding_areas: Array[Damageable] = []


func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _process(delta):
	if _damage_type == _damage_type_enum.ON_STAY:
		for area in _colliding_areas:
			area.take_damage(_damage * delta, self)


func _on_area_entered(area: Area3D) -> void:
	if area is Damageable:
		if _damage_type == _damage_type_enum.ON_ENTER:
			area.take_damage(_damage, self)
		elif _damage_type == _damage_type_enum.ON_STAY:
			_colliding_areas.append(area)


func _on_area_exited(area: Area3D) -> void:
	if area is Damageable:
		if _damage_type == _damage_type_enum.ON_EXIT:
			area.take_damage(_damage, self)
		elif _damage_type == _damage_type_enum.ON_STAY:
			# _colliding_areas is an array, so erase() can be very slow in some extreme cases
			# (e.g. erasing the first element from a large array). Because Godot doesn't have lists,
			# this isn't as easy to fix as it should be. Probably won't cause any problems,
			# because the length of this array will always be relatively small. TODO?
			_colliding_areas.erase(area)
