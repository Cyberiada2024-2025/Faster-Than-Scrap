extends Node


func _give_fuel() -> void:
	GameManager.player_ship.current_fuel += 1
