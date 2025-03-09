extends Node

signal after_finished

@export_category("Animation")
@export var leaving_body: Node3D
@export_group("Curve")
@export var rotation_curve: Curve
@export var velocity_curve: Curve
@export var scale_curve: Curve
@export var position_curve: Curve
@export_group("Animation Fragments Times")
@export var rotation_time: float = 3.0
@export var velocity_time: float = 3.0
@export var jump_time: float = 1.0

var start_angle: float
var start_linear_velocity: Vector3
var start_angular_velocity: Vector3
var start_scale: float
var start_position: float


func _ready() -> void:
	start_animation()  # to del
	pass


func start_animation() -> void:
	start_angle = leaving_body.rotation.y
	start_linear_velocity = leaving_body.linear_velocity
	start_angular_velocity = leaving_body.angular_velocity
	start_scale = leaving_body.scale.z

	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_method(rotation_tween_metod, 0.0, 1.0, rotation_time)
	tween.tween_method(velocity_tween_metod, 0.0, 1.0, velocity_time)
	tween.chain().tween_callback(prepare_to_jump)
	tween.chain().tween_method(jump, 0.0, 1.0, jump_time)
	tween.chain().tween_callback(end_animation)


func rotation_tween_metod(time: float) -> void:
	leaving_body.rotation.y = start_angle * rotation_curve.sample(time)


func velocity_tween_metod(time: float) -> void:
	leaving_body.linear_velocity = start_linear_velocity * velocity_curve.sample(time)
	leaving_body.angular_velocity = start_angular_velocity * velocity_curve.sample(time)


func prepare_to_jump() -> void:
	start_position = leaving_body.position.z


func jump(time: float) -> void:
	leaving_body.scale.z = start_scale * scale_curve.sample(time)
	leaving_body.position.z = start_position + start_scale * position_curve.sample(time)


func end_animation() -> void:
	print("end")
	pass
