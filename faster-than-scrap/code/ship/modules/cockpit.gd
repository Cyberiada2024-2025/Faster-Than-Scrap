class_name Cockpit

extends Module

## Class for cockpit
## The most important part of the ship.
## It informs the ship on death.

func _on_destroy() -> void:
	super() # call base
	ship.on_destroy() # inform ship of death

## overriden method
## cockpit isn't detachable
func detachable() -> bool:
	return false
