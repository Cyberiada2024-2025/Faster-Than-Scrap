class_name Damageable

extends Area3D

signal damaged(damage: float, source: Node)

@export var _damage_multiplier: float = 1

func _process(delta):
	print("dable")

func take_damage(damage: float, source: Node):
	damaged.emit(damage * _damage_multiplier, source)
