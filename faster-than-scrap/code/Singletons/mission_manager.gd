extends Node

var main_mission_finished = false

var missions: Array[Mission] = []

func reset() -> void:
	missions = []

func _process(_delta: float) -> void:
	if main_mission_finished:
		return

	for mission in missions:
		mission.check_finish()
		if mission.state == Mission.MissionState.FINISHED:
			if mission.priority == Mission.Priority.MAIN_QUEST:
				main_mission_finished=true
				print("MissionManager: FINISHED MAIN QUEST")
