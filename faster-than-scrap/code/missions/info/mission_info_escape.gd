class_name MissionInfoEscape

extends MissionInfo

@export var portal_position: Vector3 = Vector3.ZERO


func start(scene_root: Node) -> void:
	mission = MissionEscape.new()
	mission.info = self
	super(scene_root)


func get_node_color() -> Color:
	return Color.BLUE


func get_node_description() -> String:
	return "Mission Type:\nEscape"


func get_spawner() -> BaseEntitySpawner:
	var spawner: LineEntitySpawner = (
		preload("res://prefabs/spawners/line_enemy_spawner.tscn").instantiate()
	)
	spawner.start_point = GameManager.player_ship.position
	spawner.end_point = portal_position
	spawner.max_position_change = 30.0
	spawner.entities_count = (
		(2 + difficulty) * spawner.start_point.distance_to(spawner.end_point) / 10
	)
	return spawner
