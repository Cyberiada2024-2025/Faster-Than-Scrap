extends Node3D

@export var spawner: BaseEntitySpawner
@export var point1: Node3D
@export var point2: Node3D
@export var point3: Node3D


func _ready() -> void:
	spawner.A_point = point1.position
	spawner.B_point = point2.position
	spawner.C_point = point3.position
	spawner.entities_count = abs(
		(
			(
				spawner.A_point.x * (spawner.B_point.z - spawner.C_point.z)
				+ spawner.B_point.x * (spawner.C_point.z - spawner.A_point.z)
				+ spawner.C_point.x * (spawner.A_point.z - spawner.B_point.z)
			)
			/ 400
		)
	)
	spawner.spawn_entities()
	print(spawner.entities_count)
