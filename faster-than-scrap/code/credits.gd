extends Control

@export var animationPlayer: AnimationPlayer
@export var sceneLoader: Node


func _ready() -> void:
	animationPlayer.play("credits_text")


func exit_credits() -> void:
	sceneLoader.load_main_menu_scene()


func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		exit_credits()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "credits_text":
		exit_credits()
