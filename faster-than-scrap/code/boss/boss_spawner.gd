class_name BossSpawner

extends Node3D

## Spawn bosses on scene load, and waits for them to die.
## When all of the bosses are dead, the scene is loaded.
## If it is a miniboss mission it changes the scene to map_select, otherwise to credits.

static var boss_spawner: BossSpawner

var _bosses: Array[Boss] = []
var _scene_loader: SceneLoader

var _boss_dying: bool = false


func _enter_tree() -> void:
	boss_spawner = self


func _ready() -> void:
	_scene_loader = SceneLoader.new()
	add_child(_scene_loader)
	for boss_prefab in BossManager.bosses_to_spawn:
		_spawn_boss(boss_prefab)
	


func _process(_delta: float) -> void:
	if _all_bosses_dead():
		if BossManager.is_miniboss:
			GameManager.player_ship.leave_animation.start_animation(
				_scene_loader.load_map_selector_scene
			)
		else:
			if not _boss_dying:
				_boss_dying = true
				# wait for the boss death animation to finish
				await get_tree().create_timer(8).timeout
				GameManager.player_ship.leave_animation.start_animation(
					_scene_loader.load_credits_scene
				)


func _spawn_boss(boss_prefab: PackedScene) -> void:
	var boss_controller: ShipController = boss_prefab.instantiate()
	_bosses.append(boss_controller.ship)
	get_tree().current_scene.add_child(boss_controller)


func _all_bosses_dead() -> bool:
	for boss in _bosses:
		if boss.get_health_percentage() != 0:
			return false
	return true
