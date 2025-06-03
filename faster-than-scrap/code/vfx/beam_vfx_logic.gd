extends Node

const START_ANIM: String = "On"
const END_ANIM: String = "Off"

@export var player: AnimationPlayer
@export var holder: WaitFree

var animation_check: bool

func _ready() -> void:
	animation_check = player.has_animation(START_ANIM) && player.has_animation(END_ANIM)
	if animation_check:
		player.play(START_ANIM)

func _notification(notification):
	if (notification == NOTIFICATION_PREDELETE):
		holder.reparent(get_parent())
		if animation_check:
			player.play(END_ANIM)
		holder.wait_free()
