class_name MissionFuel

extends Mission

var info: MissionInfoFuel
# TODO: Substitute to fuel spawn
var fuel_source: Asteroid
var fuel_source_prefab = preload("res://prefabs/environment/fuel_source.tscn")


func setup() -> void:
	super()

	# create fuel source
	fuel_source = fuel_source_prefab.instantiate()
	fuel_source.add_child(create_label("FUEL"))
	MissionManager.get_tree().current_scene.add_child(fuel_source)

	# position it
	fuel_source.global_position = info.fuel_position
