extends Node

var main_mission_finished = false

var missions: Array[Mission] = []

var scene_loader: SceneLoader


func _ready() -> void:
	scene_loader = $SceneLoader


func reset() -> void:
	missions = []


func add_mission(mission: Mission) -> void:
	missions.append(mission)
	mission.finished.connect(on_mission_finished)


func on_mission_finished(mission: Mission) -> void:
	if mission.priority == MissionInfo.Priority.MAIN_QUEST:
		main_mission_finished = true
		print("MissionManager: FINISHED MAIN QUEST")
		GameManager.player_ship.leave_animation.start_animation(
			scene_loader.load_map_selector_scene
		)
