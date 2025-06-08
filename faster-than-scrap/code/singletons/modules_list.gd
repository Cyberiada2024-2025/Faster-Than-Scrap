extends Node
enum { COMMON = 5, UNCOMMON = 3, RARE = 2 }
var modules_and_chances = [
	[preload("res://prefabs/modules/frame1.tscn"), COMMON],
	[preload("res://prefabs/modules/frame2.tscn"), COMMON],
	[preload("res://prefabs/modules/battery.tscn"), UNCOMMON],
	[preload("res://prefabs/modules/shield_module.tscn"), RARE],
	[preload("res://prefabs/modules/thruster.tscn"), COMMON],
	[preload("res://prefabs/modules/weapons/beam_module.tscn"), UNCOMMON],
	[preload("res://prefabs/modules/weapons/laser_module.tscn"), COMMON],
	[preload("res://prefabs/modules/weapons/missile_module.tscn"), RARE]
]


func get_weights() -> Array[int]:
	var chances: Array[int]
	for mod in ModulesList.modules_and_chances:
		chances.append(mod[1])
	return chances


func get_packed_modules() -> Array[PackedScene]:
	var mods: Array[PackedScene]
	for mod in ModulesList.modules_and_chances:
		mods.append(mod[0])
	return mods
# we can have other lists as needed, for example with all weapons
# we can add "type" to module, and increase chance of weapons
# if player have none
