@tool
class_name MissionNode

extends MapNode

@export var mission_type: Mission.MissionType = Mission.MissionType.ESCAPE

func _set_color() -> void:
	match mission_type:
		Mission.MissionType.ESCAPE:
			modulate = Color.BLUE
		Mission.MissionType.DEFEND:
			modulate = Color.GREEN
		Mission.MissionType.GET_ITEM:
			modulate = Color.PURPLE
	super()


func get_description() -> String:
	var mission_string = ""
	match mission_type:
		Mission.MissionType.ESCAPE:
			mission_string="Escape"
		Mission.MissionType.DEFEND:
			mission_string="Defend"
		Mission.MissionType.GET_ITEM:
			mission_string="Get item"
	return "Mission Type: \n" + mission_string

func change_scene(scene_loader: SceneLoader) -> void:
	super(scene_loader)
	scene_loader.load_fly_ship_scene()
