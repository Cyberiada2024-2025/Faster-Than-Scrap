class_name BossUI

extends Control

@export var healh_bar: ProgressBar
@export var boss_name: Label

func _ready() -> void:
	boss_name.text = Boss.actual_boss.get_parent_node_3d().name

func _process(delta: float) -> void:
	healh_bar.value = Boss.actual_boss.get_health_percentage()
