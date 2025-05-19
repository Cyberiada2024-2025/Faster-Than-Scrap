extends Node

var alread_played_cutscenes: Array[String] = []


func play_cutscene(cutscene_packed_scene: PackedScene) -> void:
	var cutscene: Cutscene = cutscene_packed_scene.instantiate()
	var name = cutscene.cutscene_name
	if not name in alread_played_cutscenes:
		alread_played_cutscenes.append(name)
		# play the cutscene
		get_tree().current_scene.add_child.call_deferred(cutscene)
		await cutscene.tree_entered  # wait until the cutscene is in the tree
		await cutscene.play()
	# whatever the result delete it
	cutscene.queue_free()


func reset_cutscenes() -> void:
	alread_played_cutscenes.clear()
