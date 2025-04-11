class_name Shield

extends Node3D

@export var animator: AnimationPlayer
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
	animator.play(anim_close)


func deactivate() -> void:
	if not on:
		print("Already deactivated")
		return

	on = false
	collider.disabled = true
	animator.play_backwards(anim_close)


func take_damage() -> void:
	animator.play(anim_hit)
