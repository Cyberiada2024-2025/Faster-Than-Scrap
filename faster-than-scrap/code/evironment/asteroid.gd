class_name Asteroid
extends RigidBody3D

@export_category("Stats")
@export var hp: int = 100
@export_group("StartValues")
# parameters of start rotation speed, to prevent being static and dull
@export var start_speed_range: float = 1
@export var start_angular_speed_range: float = 1.0


func _ready() -> void:
	self.linear_velocity.x += randf_range(-start_speed_range, start_speed_range)
	self.linear_velocity.z += randf_range(-start_speed_range, start_speed_range)

	# randomize rotation speed
	self.angular_velocity.x += randf_range(-start_angular_speed_range, start_angular_speed_range)
	self.angular_velocity.y += randf_range(-start_angular_speed_range, start_angular_speed_range)
	self.angular_velocity.z += randf_range(-start_angular_speed_range, start_angular_speed_range)


func take_damage(damage: Damage) -> void:
	hp -= damage.value
	if hp <= 0:
		_on_destroy()


func _on_destroy() -> void:
	queue_free()
