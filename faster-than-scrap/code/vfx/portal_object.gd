class_name PortalObject

extends Node

@export var player: AnimationPlayer
@export var off_anim: String = "Off"


func _ready() -> void:
	player.play("RESET")


func off() -> void:
	player.play(off_anim)
