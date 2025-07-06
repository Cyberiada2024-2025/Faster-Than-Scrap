extends Node

## name of the "warning no value" animation
@export var warning_anim: String = "warning"
@export_group("Nodes")
## main bar
@export var bar_main: TextureProgressBar
@export var bar_warning: TextureProgressBar
@export var animator: AnimationPlayer


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
	animator.play(warning_anim)


## Call when maximum value displayed by bar has changed
func _on_max_change(new_max_value: float) -> void:
	if new_max_value > 300:
		bar_main.step = new_max_value / 30
		bar_main.max_value = new_max_value
		bar_warning.max_value = new_max_value
		bar_warning.value = new_max_value
	else:
		bar_warning.value = new_max_value
