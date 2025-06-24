class_name Shield

extends Node3D

@export var close_animator: AnimationPlayer
@export var hit_animator: AnimationPlayer
@export var collider: CollisionShape3D

var on = false

var anim_close = "Close"
var anim_hit = "Hit"


func activate() -> void:
	if on:
		print("Already activated")
		return

	on = true
	collider.disabled = false
	close_animator.play(anim_close)


func deactivate() -> void:
	if not on:
		print("Already deactivated")
		return

	on = false
	collider.disabled = true
	close_animator.play_backwards(anim_close)


func take_damage() -> void:
	hit_animator.play(anim_hit)
