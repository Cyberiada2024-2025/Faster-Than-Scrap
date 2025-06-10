class_name Beam

extends Node3D

const START_ANIM: String = "On"
const END_ANIM: String = "Off"

## Beam object that extends from it's start position up to the [DamageRaycast3D] beam length,
## or the raycast's collision point.

## Node that will be scaled so that it's Z size is the same as the beam's length.
@export var beam_indicator: Node3D
@export var max_length: float = 20

@export var player: AnimationPlayer
@export var holder: WaitFree

@export var mesh: MeshInstance3D
@export var length_name: String = "current_length"

@export
var hit_particle_prefab: PackedScene = preload("res://prefabs/vfx/particles/beam_particles.tscn")
var hit_particle: GPUParticles3D = null
var hit_particle_holder: WaitFree = null

var animation_check: bool
var _beam_length: float

@onready var _damage_raycast: DamageRaycast3D = $DamageRaycast3D


func _ready() -> void:
	animation_check = player.has_animation(START_ANIM) && player.has_animation(END_ANIM)
	if animation_check:
		player.play(START_ANIM)
	_damage_raycast.target_position = Vector3.FORWARD * max_length
	_beam_length = _damage_raycast.target_position.length()


func _process(_delta: float) -> void:
	if _damage_raycast.is_colliding():
		if hit_particle == null:
			hit_particle_holder = WaitFree.new()
			hit_particle = hit_particle_prefab.instantiate()
			hit_particle_holder.add_child(hit_particle)
			get_tree().current_scene.add_child(hit_particle_holder)
		else:
			hit_particle.emitting = true
		hit_particle_holder.global_position = _damage_raycast.get_collision_point()
		hit_particle_holder.look_at(_damage_raycast.global_position)
		var ray_length = _damage_raycast.global_position.distance_to(
			_damage_raycast.get_collision_point()
		)
		beam_indicator.scale.z = ray_length
		if mesh != null:
			mesh.material_override.set_shader_parameter(length_name, ray_length)
	else:
		if hit_particle != null:
			hit_particle.emitting = false
			hit_particle_holder.wait_free()
			hit_particle = null
			hit_particle_holder = null
		beam_indicator.scale.z = _beam_length
		if mesh != null:
			mesh.material_override.set_shader_parameter(length_name, _beam_length)


func _notification(notification):
	if notification == NOTIFICATION_PREDELETE:
		holder.reparent(get_parent())
		if animation_check:
			player.play(END_ANIM)
		if hit_particle != null:
			hit_particle.emitting = false
			hit_particle_holder.wait_free()
			hit_particle = null
			hit_particle_holder = null
		holder.wait_free()
