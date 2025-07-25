extends Node
enum { COMMON = 5, UNCOMMON = 3, RARE = 2 }
var modules_and_chances = [
	#frames
	[preload("res://prefabs/modules/frame1.tscn"), COMMON],
	[preload("res://prefabs/modules/frame_ball.tscn"), COMMON],
	[preload("res://prefabs/modules/frame_long1.tscn"), UNCOMMON],
	#energy
	[preload("res://prefabs/modules/battery.tscn"), UNCOMMON],
	[preload("res://prefabs/modules/battery_quad.tscn"), RARE],
	[preload("res://prefabs/modules/generator.tscn"), UNCOMMON],
	#thrusters
	[preload("res://prefabs/modules/thruster.tscn"), COMMON],
	[preload("res://prefabs/modules/thruster_negative.tscn"), RARE],
	#beams
	[preload("res://prefabs/modules/weapons/beam_module.tscn"), UNCOMMON],
	[preload("res://prefabs/modules/weapons/beam_neutron.tscn"), RARE],
	#lasers
	[preload("res://prefabs/modules/weapons/laser_module.tscn"), COMMON],
	[preload("res://prefabs/modules/weapons/minigun_module.tscn"), RARE],
	[preload("res://prefabs/modules/weapons/shotgun_module.tscn"), RARE],
	#missiles
	[preload("res://prefabs/modules/weapons/missile_module.tscn"), RARE],
	[preload("res://prefabs/modules/weapons/quad_missile_module.tscn"), RARE],
	#bumpers
	[preload("res://prefabs/modules/bumper.tscn"), UNCOMMON],
	[preload("res://prefabs/modules/bumper_wide.tscn"), RARE],
	#shield
	[preload("res://prefabs/modules/shield_module.tscn"), RARE],
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
