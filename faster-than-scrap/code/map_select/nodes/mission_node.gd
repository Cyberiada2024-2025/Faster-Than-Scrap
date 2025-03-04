@tool
class_name MissionNode

extends MapNode

@export var missionType: Mission.MissionType = Mission.MissionType.ESCAPE

func _set_color() -> void:
	match missionType:
		Mission.MissionType.ESCAPE: 
			modulate = Color.BLUE
		Mission.MissionType.DEFEND: 
			modulate = Color.GREEN
		Mission.MissionType.GET_ITEM: 
			modulate = Color.PURPLE
	super()


func get_description() -> String:
	var mission_string = ""
	match missionType:
		Mission.MissionType.ESCAPE: 
			mission_string="Escape"
		Mission.MissionType.DEFEND: 
			mission_string="Defend"
		Mission.MissionType.GET_ITEM: 
			mission_string="Get item"
	return "Mission Type: \n" + mission_string

func change_scene(sceneLoader: SceneLoader) -> void:
	super(sceneLoader)
	sceneLoader.load_fly_ship_scene()
