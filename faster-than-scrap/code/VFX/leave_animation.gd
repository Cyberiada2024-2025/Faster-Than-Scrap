extends Node

@export_category("Animation")
@export var leaving_body: Node3D
@export var particles: CPUParticles3D
@export_group("Animation Fragments Times")
@export var jump_preparation_time: float = 5.0
@export var jump_time: float = 2.0

var ending: Callable
var position_base: Vector3
var last_time: float = 0


func _ready() -> void:
	pass


func start_animation(ending_method: Callable) -> void:
	self.ending = ending_method
	var tween = get_tree().create_tween()
	tween.tween_callback(prepare_to_jump)
	tween.tween_interval(jump_preparation_time)
	tween.tween_callback(jump)
	tween.tween_interval(jump_time)
	tween.tween_callback(end_animation).set_delay(jump_time)


func prepare_to_jump() -> void:
	particles.reparent(leaving_body.cockpit)
	particles.emitting = true
	pass


func jump() -> void:
	particles.emitting = false
	particles.reparent(self)
	leaving_body.visible = false
	pass


func end_animation() -> void:
	leaving_body.visible = true
	self.ending.call()
