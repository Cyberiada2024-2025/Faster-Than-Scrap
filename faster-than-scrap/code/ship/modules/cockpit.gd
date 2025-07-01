class_name Cockpit

extends Module

## Class for cockpit
## The most important part of the ship.
## It informs the ship on death.


func _enter_tree() -> void:
	if not SettingsManager.brakes_enabled:
		var cockpit_sprite = $ModuleDisplay/Sprite3D
		var texture = load("res://art/textures/ui/module icons/placeholder/Cockpit Icon.png")
		cockpit_sprite.texture = texture


func _on_destroy() -> void:
	ship.on_destroy()  # inform ship of death
	super()  # call base


## overriden method
## cockpit isn't detachable
func detachable() -> bool:
	return false


func _on_key(_delta: float) -> void:
	if SettingsManager.brakes_enabled:
		ship.linear_damp = 2
		ship.angular_damp = 2


func _on_release(_delta: float) -> void:
	if !SettingsManager.brakes_enabled:
		return
	if SettingsManager.air_resistance:
		ship.linear_damp = ship.linear_damp_value
		ship.angular_damp = ship.angular_damp_value
	else:
		ship.linear_damp = 0
		ship.angular_damp = 0
