class_name MissionFuel

extends Mission

@export var fuel_position: Node3D
# TODO: Substitute to fuel spawn
var fuel_source: Asteroid
var fuel_source_prefab = preload("res://prefabs/environment/mission_related/fuel_source.tscn")

var fuel_mission_tutorial_cutscene = preload(
	"res://prefabs/ui/cutscenes/tutorials/missions/fuel_mission_tutorial.tscn"
)


func setup() -> void:
	super()

	# create fuel source
	fuel_source = fuel_source_prefab.instantiate()
	fuel_source.add_child(create_label("FUEL"))
	MissionManager.get_tree().current_scene.add_child.call_deferred(fuel_source)

	# position it
	fuel_source.global_position = fuel_position.global_position
	_spawn_vortex(fuel_position.global_position)

	CutsceneManager.play_cutscene(fuel_mission_tutorial_cutscene)
