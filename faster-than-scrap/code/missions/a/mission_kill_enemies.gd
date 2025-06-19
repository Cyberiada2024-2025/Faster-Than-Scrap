class_name MissionKillEnemies

extends Mission

@export var vortex_center: Node3D


func setup() -> void:
	super()
	_spawn_vortex(vortex_center.global_position)


func _process(_delta: float) -> void:
	super(_delta)
	if _ended():
		return

	var enemies = GameManager.find_all_enemies(TeamManager.Team.PLAYER)
	if len(enemies) == 0:
		print("ALL ENEMIES DEFEATED")
		state = MissionState.FINISHED
		finished.emit(self)
