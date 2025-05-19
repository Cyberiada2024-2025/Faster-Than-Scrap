extends Node

signal finished

@export var cutscene_path: PackedScene


func _ready() -> void:
	await CutsceneManager.play_cutscene(cutscene_path)
	finished.emit()
