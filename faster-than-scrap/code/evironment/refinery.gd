class_name Refinery
extends RigidBody3D

@export_category("Stats")
@export var hp: float = 100
@export_group("StartValues")


func take_damage(damage: Damage) -> void:
	hp -= damage.value
	if hp <= 0:
		_on_destroy()


func _on_destroy() -> void:
	queue_free()
