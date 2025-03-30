class_name LeavingAnimation

extends Node3D

@export_category("Animation")
@export var leaving_body: Node3D
@export var prepare_particles: GPUParticles3D
@export var anim_player: AnimationPlayer
@export_group("animation names")
@export var prepere_anim_name: StringName = "prepere_to_jump"
@export var jump_anim_name: StringName = "jump"
@export_group("animation times")
@export var prepere_time: float = 4.0
@export var jump_time: float = 2.0

var ending: Callable
var position_base: Vector3
var last_time: float = 0
var callable: bool = true


func _process(_delta: float) -> void:
	pass


func start_animation(ending_method: Callable) -> void:
	if callable:
		callable = false
		ending = ending_method
		anim_player.play(prepere_anim_name, -1, 1 / prepere_time)


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == prepere_anim_name:
		anim_player.play(jump_anim_name, -1, 1 / jump_time)
	elif anim_name == jump_anim_name:
		callable = true
		ending.call()
