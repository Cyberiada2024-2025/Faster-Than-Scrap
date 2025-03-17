extends Control

@export var animationPlayer: AnimationPlayer
@export var sceneLoader: Node


func _ready() -> void:
	animationPlayer.play("credits_text")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "credits_text":
		sceneLoader.load_main_menu_scene()
