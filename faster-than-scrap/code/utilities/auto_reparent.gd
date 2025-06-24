class_name AutoReparent
extends Node

## Reparents iteself in ready to scene root


func _ready() -> void:
	reparent.call_deferred(get_tree().current_scene)
