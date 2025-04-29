extends Node


func play_cutscene(cutscene_packed_scene: PackedScene) -> void:
	var cutscene: Cutscene = cutscene_packed_scene.instantiate()
	get_tree().current_scene.add_child.call_deferred(cutscene)
	await cutscene.tree_entered  # wait until the cutscene is in the tree
	await cutscene.play()
	cutscene.queue_free()
