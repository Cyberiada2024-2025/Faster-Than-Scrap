extends RigidBody3D

@export_category("Nodes")
@export var collision_damage_calculator: Node
@export_category("Stats")
@export var hp: int = 100
@export var dealt_damage_multiplier: int = 10
@export var self_damage_multiplier: int = 3
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


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("take damege from collisions"):
		var damage: Dictionary = collision_damage_calculator.calculate_damage(self, body)
		body.take_damage(damage["dealt_damage"])
		self.take_damage(damage["self_damage"])
