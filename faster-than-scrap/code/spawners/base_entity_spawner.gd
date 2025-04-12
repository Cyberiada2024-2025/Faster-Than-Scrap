class_name BaseEntitySpawner

extends Node

@export_category("Spawner")
@export var spawned_entities: Array[PackedScene]
@export var entities_count: int
@export var max_position_change: float = 0
@export var nodes_location_in_tree: Node = self
@export_group("y spawn")
@export var min_y: float = 0
@export var max_y: float = 0


func spawn_entities():
	pass
