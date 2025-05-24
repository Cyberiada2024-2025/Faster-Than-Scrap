class_name FuelDisplay
extends Control

@export var fuel_display: Label


func _ready() -> void:
	# set fuel display default value
	fuel_display.text = str(GameManager.player_ship.current_fuel)
	GameManager.player_ship.fuel_change.connect(
		func(new_value: int): fuel_display.text = str(new_value)
	)
