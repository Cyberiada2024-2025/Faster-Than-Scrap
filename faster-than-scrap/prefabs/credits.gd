extends Control

@export var animationPlayer: AnimationPlayer


func _ready() -> void:
	animationPlayer.play("credits_text")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "credits_text":
		print("sfdsf")
