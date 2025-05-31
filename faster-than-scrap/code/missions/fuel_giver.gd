extends Node

@export var fuel_to_give: int = 1


func _give_fuel() -> void:
	GameManager.player_ship.current_fuel += fuel_to_give
