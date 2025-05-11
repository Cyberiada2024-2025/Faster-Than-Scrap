extends Node3D

@export var spawner: BaseEntitySpawner
@export var point1: Node3D
@export var point2: Node3D
@export var point3: Node3D


func _ready() -> void:
	spawner.spawn_entities()
	print(spawner.entities_count)
