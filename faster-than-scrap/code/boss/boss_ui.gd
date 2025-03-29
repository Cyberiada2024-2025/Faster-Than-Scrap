class_name BossUI

extends Control

@export var healh_bar: ProgressBar
@export var boss_name: Label

var boss: Boss


func _ready() -> void:
	_get_boss_name.call_deferred()


func _process(delta: float) -> void:
	if boss != null:
		healh_bar.value = boss.get_health_percentage()


func _get_boss_name() -> void:
	var bosses = BossSpawner.boss_spawner._bosses
	boss = bosses[0]
	boss_name.text = boss.get_parent_node_3d().name
