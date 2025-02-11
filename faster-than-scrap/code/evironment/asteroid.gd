extends RigidBody3D

@export_category('Stats')
@export var hp : int = 100
@export var damage_multiplier : int = 10
@export_group('StartValues')
@export var START_SPEED_RANGE : float = 10.0
@export var START_SIZE_RANGE : float = 10.0


func _ready() -> void:
	self.linear_velocity.x = randf_range(-START_SPEED_RANGE, START_SPEED_RANGE)
	self.linear_velocity.z = randf_range(-START_SPEED_RANGE, START_SPEED_RANGE)
	self.scale *= randf_range(1.0, START_SIZE_RANGE)
	hp *= self.scale.x


func _process(delta: float) -> void:
	pass


func take_damage(damage: int) -> void:
	hp -= damage
	print('damaged')
	print(damage)
	if hp <=0 :
		print('detroyed')
		_on_destroy()

func _on_destroy() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("take damege from asteroids"):
		print('hit')
		body.take_damage(((self.scale.x * self.linear_velocity.length()) + body.linear_velocity.length()) * damage_multiplier)
