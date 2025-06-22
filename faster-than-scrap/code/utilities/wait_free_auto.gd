class_name WaitFreeAuto
extends WaitFree

## Extension of wait free, where it automaticaly wait_free itself on ready and detaches
## from its parent.


func _ready() -> void:
	reparent.call_deferred(get_tree().current_scene)
	wait_free()
