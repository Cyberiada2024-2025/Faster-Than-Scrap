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

## The projectile's collisions will be activated after waiting this number of seconds
@export var collision_activation_delay: float = 0.075

## Projectiles don't dissappear immidietly
@export var particle_holder: WaitFree
@export var particles: Array[GPUParticles3D]

## Additional velocity applied to the projectile in every frame.
## Used for applying the ship's speed to projectile after spawning.
var velocity_offset: Vector3 = Vector3.ZERO

var _current_lifetime: float = 0

@onready var _damage_area: DamageArea3D = $DamageArea3D


func _ready() -> void:
	if collision_activation_delay > 0:
		_damage_area.monitoring = false
		get_tree().create_timer(collision_activation_delay).timeout.connect(
			func(): _damage_area.monitoring = true
		)

	_damage_area.damage_applied.connect(_on_damage_applied)
	for part in particles:
		part.emitting = true


func _process(delta: float) -> void:
	_process_movement(delta)

	_current_lifetime += delta
	if _current_lifetime >= lifetime:
		queue_free()


func _process_movement(delta: float) -> void:
	global_position += velocity_offset * delta
	var speed = velocity.sample_baked(_current_lifetime / lifetime)
	speed *= velocity_multiplier
	translate_object_local(Vector3.FORWARD * speed * delta)


func _on_damage_applied(_damage: Damage, _target: Damageable) -> void:
	if die_on_hit:
		if particle_holder != null:
			for part in particles:
				part.emitting = false
			particle_holder.wait_free()
			particle_holder.reparent(get_tree().current_scene)
		queue_free()
