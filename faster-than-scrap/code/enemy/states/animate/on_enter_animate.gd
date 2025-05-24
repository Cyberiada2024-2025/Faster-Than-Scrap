class_name StateAnimate

extends StateNPC

@export var animator: AnimationPlayer
@export var animation_name: String = "Anim"

func enter(_previous_state_path: String, _data := {}) -> void:
	animator.play(animation_name)
