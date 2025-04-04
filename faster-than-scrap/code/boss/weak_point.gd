class_name WeakPoint

extends Module

@export var damage: Damage
@export var damage_target: Module

## Destroy self and detach children
func _on_destroy() -> void:
	super()
	damage_target.take_damage(damage)
