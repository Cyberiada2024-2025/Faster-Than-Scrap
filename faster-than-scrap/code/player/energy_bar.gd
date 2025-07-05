extends Node

@export_group("Nodes")
## main bar
@export var bar_main: TextureProgressBar


func _ready() -> void:
	var player_ship = GameManager.player_ship
	player_ship.energy_max_change.connect(_on_max_change)
	player_ship.energy_change.connect(_change_value)
	player_ship.energy_warning.connect(_on_warning)

	_on_max_change(player_ship.max_energy)
	_change_value(player_ship.energy)


## Call when value displayed by the bar has changed
func _change_value(input: float) -> void:
	bar_main.value = input


## Call when user tries to use more resource then they have
func _on_warning() -> void:
	pass


## Call when maximum value displayed by bar has changed
func _on_max_change(new_max_value: float) -> void:
	bar_main.max_value = new_max_value
	bar_main.step = new_max_value / 30
