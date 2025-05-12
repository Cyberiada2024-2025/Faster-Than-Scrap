extends Node

@export var player: AnimationPlayer
@export var holder: WaitFree

const start_anim: String = "On"
const end_anim: String = "Off"

var animation_check: bool

func _ready() -> void:
	animation_check = player.has_animation(start_anim) && player.has_animation(end_anim)
	if animation_check:
		player.play(start_anim)

func _notification(notification):
	if (notification == NOTIFICATION_PREDELETE):
		holder.reparent(get_parent())
		if animation_check:
			player.play(end_anim)
		holder.wait_free()
