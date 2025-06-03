class_name EnemySpawner
extends CapturePoint

@export var enemy_prefab: PackedScene = preload("res://prefabs/npc/enemies/fighter.tscn")
@export var spawn_range: float = 40
@export var spawn_interval: float = 5
@export var max_enemies: int = 3

var _spawn_timer: float = spawn_interval
var _spawned_enemies: Array[NPC] = []


func _process(delta: float) -> void:
	if _captured:
		return
	super(delta)

	_spawn_timer -= delta
	if _spawn_timer <= 0 and _spawned_enemies.size() < max_enemies and _player_in_range:
		_spawn_timer = spawn_interval
		_spawn()


func _spawn() -> void:
	var enemy: NPC = enemy_prefab.instantiate()
	var offset_2d = RandomUtils._random_on_edge_unit_circle() * spawn_range
	var offset_3d = Vector3(offset_2d.x, 0, offset_2d.y)
	get_tree().current_scene.add_child.call_deferred(enemy)
	enemy.global_position = global_position + offset_3d
	_spawned_enemies.append(enemy)

	enemy.ship.destroyed.connect(_remove_enemy)


func _remove_enemy(enemy: Ship) -> void:
	ArrayUtils.remove_by_field(_spawned_enemies, "ship", enemy)
