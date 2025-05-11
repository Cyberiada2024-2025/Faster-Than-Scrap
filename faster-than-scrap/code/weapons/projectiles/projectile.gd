class_name Projectile

extends Node3D

## A projectile that moves forward and dies after
## a certain amount of time has passed.

## Curve representing the projectile's velocity in time.
## [code]X = 1[/code] on the curve represents the end of the projectile's lifetime.
@export var velocity: Curve

## Velocity from the [param velocity] curve will be multiplied by this number.
## This makes it easier to quickly adjust the projectile's speed.
@export var velocity_multiplier: float = 1

## How much time passes before the projectile dies on it's own.
@export var lifetime: float

## If true, the projectile will die immediately after hitting something.
## Otherwise it will keep going until the end of its lifetime. [br]
## Note: In both cases, die_on_hit in the child [DamageArea3D] should be set to false.
@export var die_on_hit: bool = true

@export_group("Particles")
## Particles spawned after Projectile die
@export var death_particles: PackedScene = preload(
	"res://prefabs/vfx/particles/base_projectile_death_particles.tscn"
)
## Particles spawned after Projectile hits if it doesnt die
@export var hit_particles: PackedScene = preload(
	"res://prefabs/vfx/particles/base_projectile_hit_particles.tscn"
)

var _current_lifetime: float = 0

@onready var _damage_area: DamageArea3D = $DamageArea3D


func _ready():
	_damage_area.damage_applied.connect(_on_damage_applied)


func _process(delta: float) -> void:
	_process_movement(delta)

	_current_lifetime += delta
	if _current_lifetime >= lifetime:
		queue_free()


func _process_movement(delta: float) -> void:
	var speed = velocity.sample_baked(_current_lifetime / lifetime)
	speed *= velocity_multiplier
	translate_object_local(Vector3.FORWARD * speed * delta)


func _on_damage_applied(_damage: Damage, _target: Damageable) -> void:
	if die_on_hit:
		if death_particles:
			var particle = death_particles.instantiate()
			particle.position = global_position
			get_tree().current_scene.add_child(particle)
		queue_free()
	else:
		if hit_particles:
			var particle = hit_particles.instantiate()
			particle.position = global_position
			get_tree().current_scene.add_child(particle)
