extends Node

## class used for tutorial cutscene to trigger on certain level of energy

signal player_low_energy

@export var percentage: float = 0.5

var triggered: bool = false


func _process(_delta: float) -> void:
	if triggered:
		return

	var player = GameManager.player_ship
	if player.energy < player.max_energy / 1.4:
		triggered = true
		player_low_energy.emit()
