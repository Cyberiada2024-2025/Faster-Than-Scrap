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
	super()  # call base
	ship.on_destroy()  # inform ship of death


## overriden method
## cockpit isn't detachable
func detachable() -> bool:
	return false


func _on_key(_delta: float) -> void:
	ship.linear_damp = 2
	ship.angular_damp = 2


func _on_release(_delta: float) -> void:
	# TODO Set this to default state (could be different, depending on air resistance)
	ship.linear_damp = ship.linear_damp_value
	ship.angular_damp = ship.angular_damp_value
