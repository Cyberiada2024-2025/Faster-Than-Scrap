class_name SetupFlySceneWithLineGenerator

extends SetupFlyScene

var spawner: BaseEntitySpawner


func _ready() -> void:
	MapGenerator.generate_map()
	spawner = MapGenerator._map_node.mission_info.get_spawner()
	spawner.nodes_location_in_tree = $"../Enemies"
	add_child(spawner)
	spawner.spawn_entities()
