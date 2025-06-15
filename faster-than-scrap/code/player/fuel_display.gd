class_name FuelDisplay
extends Control

@export var fuel_display: Label


func _ready() -> void:
	# set fuel display default value
	_update_fuel_display(GameManager.player_ship.current_fuel)
	GameManager.player_ship.fuel_change.connect(
		func(new_value: int): _update_fuel_display(new_value)
	)


func _update_fuel_display(amount: int) -> void:
	if amount == 0:
		# hide self
		hide()
	else:
		# show it
		show()
		fuel_display.text = str(amount)
