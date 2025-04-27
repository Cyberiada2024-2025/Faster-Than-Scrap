extends Node


func play_cutscene(cutscene_packed_scene: PackedScene) -> void:
	var cutscene: Cutscene = cutscene_packed_scene.instantiate()
	var current = get_tree().current_scene
	get_tree().current_scene.add_child.call_deferred(cutscene)
