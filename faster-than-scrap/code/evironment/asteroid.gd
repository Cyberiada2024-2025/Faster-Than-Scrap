class_name Asteroid
extends RigidBody3D

@export_category("Stats")
@export var hp: int = 100
@export_group("StartValues")
@export var start_speed_range: float = 10.0


func _ready() -> void:
	self.linear_velocity.x += randf_range(-start_speed_range, start_speed_range)
	self.linear_velocity.z += randf_range(-start_speed_range, start_speed_range)


func take_damage(damage: int) -> void:
	hp -= damage
	if hp <= 0:
		_on_destroy()


func _on_destroy() -> void:
	queue_free()
