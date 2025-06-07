class_name CutscenePlayer
extends Node

signal finished

@export var cutscene_path: PackedScene
@export var play_on_ready: bool = false


func _ready() -> void:
	if play_on_ready:
		await CutsceneManager.play_cutscene(cutscene_path)
		finished.emit()


func play() -> void:
	await CutsceneManager.play_cutscene(cutscene_path)
	finished.emit()
