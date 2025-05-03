extends Node

@export var player: AnimationPlayer
@export var start_anim: String = "On"
@export var end_anim: String = "Off"
@export var holder: WaitFree
@export var end_time: float = 1.0

func _ready() -> void:
	player.play(start_anim)
	self.remove_child(holder)
	self.get_parent().add_child(holder)

func _notification(notification):
	if (notification == NOTIFICATION_PREDELETE):
		player.play(end_anim)
		holder.wait_free(end_time)
