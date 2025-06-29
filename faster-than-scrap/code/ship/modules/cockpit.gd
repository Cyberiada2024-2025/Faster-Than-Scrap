class_name Cockpit

extends Module

## Class for cockpit
## The most important part of the ship.
## It informs the ship on death.

var cockpit_sprite
var cockpit_label
var cockpit_texture = load("res://art/textures/ui/module icons/placeholder/Cockpit Icon.png")
var default_texture = load("res://art/textures/ui/minimap/placeholder/Enemy.png")


func _enter_tree() -> void:
	cockpit_sprite = $ModuleDisplay/Sprite3D
	cockpit_label = $ModuleDisplay/Label3D


func _on_destroy() -> void:
	super()  # call base
	ship.on_destroy()  # inform ship of death


## overriden method
## cockpit isn't detachable
func detachable() -> bool:
	return false


func _on_key(_delta: float) -> void:
	if SettingsManager.brakes_enabled:
		ship.linear_damp = 2
		ship.angular_damp = 2


func _on_release(_delta: float) -> void:
	if SettingsManager.brakes_enabled:
		GameManager.player_ship.change_air_resistance()
