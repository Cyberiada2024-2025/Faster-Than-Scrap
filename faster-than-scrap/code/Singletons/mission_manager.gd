extends Node

var main_mission_finished = false

var missions: Array[Mission] = []


func reset() -> void:
	missions = []


func on_mission_finished(mission: Mission) -> void:
	if mission.info.priority == MissionInfo.Priority.MAIN_QUEST:
		main_mission_finished = true
		print("MissionManager: FINISHED MAIN QUEST")
