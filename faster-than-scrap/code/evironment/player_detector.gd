class_name PlayerDetector

extends Area3D

signal player_entered

## The player detector will not emit any signals for this number of seconds after entering the tree,
## regardless of whether the player has entered the tree or not.
@export var instantiated_cooldown: float = 0

var _time_instantiated: float


func _enter_tree():
	_time_instantiated = Time.get_unix_time_from_system()


func _ready() -> void:
	body_entered.connect(_check_if_player)


func _check_if_player(body: Node3D) -> void:
	var current_time = Time.get_unix_time_from_system()
	if current_time - _time_instantiated < instantiated_cooldown:
		return

	if body == GameManager.player_ship:
		player_entered.emit()
