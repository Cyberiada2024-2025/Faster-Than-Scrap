@tool
class_name DamageController

extends Node

## Controls the damage applied to a node with multiple [Damageable] nodes
## (for example, an enemy with multiple damageable areas, a module with a weak point, etc.) [br]
## DamageController isn't necessarily required in case of just one [Damageable], but should probably
## be used for the sake of consistency.

## Emitted when any of the child [Damageable] nodes takes damage.
## The signal is emitted at most once per frame,
## and contains all damage that should be applied for that frame.
signal damaged(damage: float)

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


var _damage: Dictionary = {}


func _ready():
	if Engine.is_editor_hint():
		return

	# DamageController should be processed last, after all the damage has been inflicted.
	set_process_priority(1000000)

	for child in get_children():
		if child is Damageable:
			child.damaged.connect(_add_damage)


func _add_damage(damage: float, source: Node):
	if source in _damage:
		_damage[source].append(damage)
	else:
		_damage[source] = [damage]


func _process(_delta):
	if Engine.is_editor_hint():
		return

	var total_damage: float = 0
	for source in _damage:
		var damage_list = _damage[source]
		match _damage_mode:
			DamageMode.LOWEST:
				total_damage += damage_list.min()
			DamageMode.HIGHEST:
				total_damage += damage_list.max()
			DamageMode.ALL:
				for damage in damage_list:
					total_damage += damage

	if total_damage > 0:
		damaged.emit(total_damage)


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
