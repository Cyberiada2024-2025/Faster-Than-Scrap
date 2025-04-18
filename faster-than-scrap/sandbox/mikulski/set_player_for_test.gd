extends Node

@export var player: PlayerShip
@export var mission: Node
var time: float = 0


func _ready() -> void:
	GameManager.player_ship = player
