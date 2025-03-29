class_name PlayerDetector

extends Area3D

signal player_entered


func _ready() -> void:
	body_entered.connect(_check_if_player)


func _check_if_player(body: Node3D) -> void:
	if body == GameManager.player_ship:
		player_entered.emit()
