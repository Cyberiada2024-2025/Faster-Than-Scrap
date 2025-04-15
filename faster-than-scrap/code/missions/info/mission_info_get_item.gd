class_name MissionInfoGetItem

extends MissionInfo

@export var item_position: Vector3 = Vector3.ZERO
@export var item_target_position: Vector3 = Vector3.ZERO


func start(scene_root: Node) -> void:
	mission = MissionGetItem.new()
	mission.info = self
	super(scene_root)


func get_node_color() -> Color:
	return Color.PURPLE


func get_node_description() -> String:
	return "Mission Type:\nGet item"


func get_spawner() -> BaseEntitySpawner:
	var spawner: TriangleEntitySpawner = (
		preload("res://prefabs/spawners/triangle_enemy_spawner.tscn").instantiate()
	)
	spawner.A_point = GameManager.player_ship.position
	spawner.B_point = item_position
	spawner.C_point = item_target_position
	spawner.max_position_change = 10.0
	spawner.entities_count = (
		(
			(2 + difficulty)
			* abs(
				(
					(
						spawner.A_point.x * (spawner.B_point.z - spawner.C_point.z)
						+ spawner.B_point.x * (spawner.C_point.z - spawner.A_point.z)
						+ spawner.C_point.x * (spawner.A_point.z - spawner.B_point.z)
					)
					/ 400
				)
			)
		)
		+ 5
	)
	return spawner
