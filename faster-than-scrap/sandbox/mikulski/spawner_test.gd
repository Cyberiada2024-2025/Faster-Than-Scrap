extends Node3D

@export var spawner: BaseEntitySpawner
@export var points: Array[Node3D]


func _ready() -> void:
	var p: Array[Vector3]
	for node in points:
		p.append(node.position)
	spawner.set_spawner(p, 1)
	spawner.spawn_entities()
	print(spawner.entities_count)
