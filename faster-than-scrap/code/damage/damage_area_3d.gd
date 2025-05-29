class_name DamageArea3D

extends Area3D

## Area3D which damages all [Damageable] nodes that are in it. [br]
## Should mostly be used for actual area collisions.
## For other collisions (e.g. projectiles), use [DamageRaycast3D].

## Signal emitted everytime this node applies damage to a [Damageable] node.
signal damage_applied(damage: Damage, target: Damageable)

enum DamageType {
	## The damage will be applied only to [Damageable] nodes that have just entered the area.
	ON_ENTER,
	## The damage will be applied on every frame to [Damageable] nodes that are currently colliding
	## with the area. In this mode [member _damage] specifies damage [i]per second[/i], not per frame.
	ON_STAY,
	## The damage will be applied only to [Damageable] nodes that have just exited the area.
	ON_EXIT
}

## Determines how and when the damage should be applied. See [enum DamageType] for possible values.
@export var _damage_type: DamageType = DamageType.ON_STAY

## How much damage does the area deal to [Damageable] nodes.
## If [member _damage_type] is set to [code]ON_STAY[/code], specifies damage per second.
@export var _damage: Damage

## If set to true, this node will be destroyed immediately after applying damage.
@export var _die_on_hit: bool = false

## The collision will start monitoring after waiting this number of seconds
@export var collision_activation_delay: float = 0

var _colliding_areas: Array[Damageable] = []


func _ready():
	if collision_activation_delay > 0:
		monitoring = false
		get_tree().create_timer(collision_activation_delay).timeout.connect(
			func(): monitoring = true
		)
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _process(delta):
	if _damage_type == DamageType.ON_STAY:
		for area in _colliding_areas:
			_apply_damage(_damage.multiply(delta), area)


func _apply_damage(damage: Damage, target: Damageable) -> void:
	target.take_damage(damage, self)
	damage_applied.emit(damage, target)
	if _die_on_hit:
		queue_free()


func _on_area_entered(area: Area3D) -> void:
	if area is Damageable:
		if _damage_type == DamageType.ON_ENTER:
			_apply_damage(_damage, area)
		elif _damage_type == DamageType.ON_STAY:
			_colliding_areas.append(area)


func _on_area_exited(area: Area3D) -> void:
	if area is Damageable:
		if _damage_type == DamageType.ON_EXIT:
			_apply_damage(_damage, area)
		elif _damage_type == DamageType.ON_STAY:
			# _colliding_areas is an array, so erase() can be very slow in some extreme cases
			# (e.g. erasing the first element from a large array). Because Godot doesn't have lists,
			# this isn't as easy to fix as it should be. Probably won't cause any problems,
			# because the length of this array will always be relatively small. TODO?
			_colliding_areas.erase(area)
