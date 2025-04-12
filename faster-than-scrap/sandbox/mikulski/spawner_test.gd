extends Node3D

@export var spawner: EntitySpawner
@export var point1: Node3D
@export var point2: Node3D


func _ready() -> void:
	spawner.points[0] = point1.position
	spawner.points[1] = point2.position
	spawner.spawn_entities()
