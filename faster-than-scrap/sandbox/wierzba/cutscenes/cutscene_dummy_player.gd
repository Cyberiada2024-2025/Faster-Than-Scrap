extends Node

@export var cutscene_path: PackedScene


func _ready() -> void:
	CutsceneManager.play_cutscene(cutscene_path)
