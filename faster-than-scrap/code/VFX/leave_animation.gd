extends Node

@export_category("Animation")
@export var leaving_body: Node3D
@export var prepare_particles: CPUParticles3D
@export var jump_player: AnimationPlayer
@export_group("Animation Fragments Times")
@export var jump_preparation_time: float = 5.0
@export var jump_time: float = 1.0

var ending: Callable
var position_base: Vector3
var last_time: float = 0


func _ready() -> void:
	jump_player.speed_scale = 1 / jump_time


func start_animation(ending_method: Callable) -> void:
	self.ending = ending_method
	var tween = get_tree().create_tween()
	tween.tween_callback(prepare_to_jump)
	tween.tween_interval(jump_preparation_time)
	tween.tween_callback(jump)
	tween.tween_interval(jump_time)
	tween.tween_callback(end_animation).set_delay(jump_time)


func prepare_to_jump() -> void:
	prepare_particles.reparent(leaving_body.cockpit)
	prepare_particles.emitting = true


func jump() -> void:
	prepare_particles.emitting = false
	prepare_particles.reparent(self)
	leaving_body.visible = false
	jump_player.get_child(0).position = leaving_body.cockpit.position
	jump_player.play("jump")


func end_animation() -> void:
	leaving_body.visible = true
	self.ending.call()
