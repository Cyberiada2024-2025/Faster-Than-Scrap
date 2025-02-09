@tool
class_name DamageController

extends Node3D

signal damaged(damage: float)

enum _damage_mode_enum {HIGHEST, LOWEST, ALL}
@export var _damage_mode: _damage_mode_enum = _damage_mode_enum.LOWEST


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


func _process(delta):
	if Engine.is_editor_hint():
		return
		
	var total_damage: float = 0
	for source in _damage:
		var damage_list = _damage[source]
		match _damage_mode:
			_damage_mode_enum.LOWEST:
				total_damage += min(damage_list)
			_damage_mode_enum.HIGHEST:
				total_damage += max(damage_list)
			_damage_mode_enum.ALL:
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
		var warning_text = "Damage controller needs at least one damageable children.\n"
		warning_text += "Please add a Damageable node as a direct child of this node."
		warnings.append(warning_text)

	return warnings
