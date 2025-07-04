class_name LeavingAnimation

extends Node3D

@export var jump_sound_emitter: SoundEmitter
@export_category("Animation")
@export var prepare_particles: GPUParticles3D
@export var anim_player: AnimationPlayer
@export_group("animation names")
@export var prepare_anim_name: StringName = "prepare_to_jump"
@export var jump_anim_name: StringName = "jump"
@export_group("animation times")
@export var prepare_time: float = 1.0
@export var jump_time: float = 1.0

@export var downwards_curve: Curve
@export var minimum_y: float = -10

var player: PlayerShip
var animating = false
var anim_timer: float = 0
var saved_transform: Transform3D

var ending: Callable
## variable that block multiple activation of this animation
var callable: bool = true


func _ready() -> void:
	player = GameManager.player_ship
	prepare_particles.speed_scale = 6 / (prepare_time + jump_time)


func _process(_delta: float) -> void:
	if animating:
		anim_timer += _delta
		player.transform = saved_transform
		var sample = downwards_curve.sample(anim_timer / (jump_time + prepare_time))
		player.position += Vector3.UP * minimum_y * sample


func start_animation(ending_method: Callable) -> void:
	if callable:
		callable = false
		ending = ending_method
		if get_tree().current_scene.name == "BossScene":
			anim_player.play("aegis", -1, 1)
		else:
			anim_player.play(prepare_anim_name, -1, 1 / prepare_time)
			animating = true
			saved_transform = player.transform
		anim_timer = 0
		if jump_sound_emitter:
			jump_sound_emitter.start_playing()


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "aegis":
		anim_player.play(prepare_anim_name, -1, 1 / prepare_time)
		animating = true
		saved_transform = player.transform
	elif anim_name == prepare_anim_name:
		anim_player.play(jump_anim_name, -1, 1 / jump_time)
	elif anim_name == jump_anim_name:
		callable = true
		animating = false
		ending.call()
