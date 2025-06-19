@tool
class_name DamageController

extends Node3D

## Controls the damage applied to a node with multiple [Damageable] nodes
## (for example, an enemy with multiple damageable areas, a module with a weak point, etc.) [br]
## DamageController isn't necessarily required in case of just one [Damageable], but should probably
## be used for the sake of consistency.

## Emitted when any of the child [Damageable] nodes takes damage.
## The signal is emitted at most once per frame,
## and contains all damage that should be applied for that frame.
signal damaged(damage: Damage)

enum DamageMode {
	## When multiple [Damageable] nodes take damage from the same source,
	## only the highest damage will be applied.
	HIGHEST,
	## When multiple [Damageable] nodes take damage from the same source,
	## only the lowest damage will be applied.
	LOWEST,
	## When multiple [Damageable] nodes take damage from the same source,
	## all of the damage will be applied.
	ALL,
}

## Specifies the behaviour of what happens when multiple [Damageable] nodes
## (possibly with different damage multipliers) take damage from the same source.
## See [enum DamageMode] for possible values.
@export var _damage_mode: DamageMode = DamageMode.LOWEST

## Spaghetti
@export var _damaged_sound_emitter: SoundEmitter

var _damage: Dictionary = {}


func _ready():
	if Engine.is_editor_hint():
		return

	# DamageController should be processed last, after all the damage has been inflicted.
	set_process_priority(1000000)

	for child in get_children():
		if child is Damageable:
			child.damaged.connect(_add_damage)


func _add_damage(damage: Damage, source: Node):
	if source in _damage:
		_damage[source].append(damage)
	else:
		_damage[source] = [damage]


func _process(_delta):
	if Engine.is_editor_hint():
		return

	var total_damage: Damage = null
	for source in _damage:
		var damage_list = _damage[source]
		var damage_to_add: Damage
		match _damage_mode:
			DamageMode.LOWEST:
				damage_to_add = ArrayUtils.min_custom(damage_list, Damage.compare)
			DamageMode.HIGHEST:
				damage_to_add = ArrayUtils.max_custom(damage_list, Damage.compare)
			DamageMode.ALL:
				for damage in damage_list:
					if damage_to_add == null:
						damage_to_add = damage
					else:
						damage_to_add = damage_to_add.add(damage)
		if total_damage == null:
			total_damage = damage_to_add
		else:
			total_damage = total_damage.add(damage_to_add)

	if total_damage != null and total_damage.value > 0:
		damaged.emit(total_damage)
		_damage = {}

		# spaghetti
		if _damaged_sound_emitter != null and total_damage.type == Damage.Type.NORMAL:
			_damaged_sound_emitter.start_playing()


func _get_configuration_warnings():
	var warnings = []

	var damageable_children_count = 0
	for child in get_children():
		if child is Damageable:
			damageable_children_count += 1

	if damageable_children_count == 0:
		var warning_text = "DamageController needs at least one damageable children.\n"
		warning_text += "Please add a Damageable node as a direct child of this node."
		warnings.append(warning_text)

	return warnings
