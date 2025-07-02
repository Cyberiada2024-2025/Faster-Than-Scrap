extends Node

var alread_played_cutscenes: Array[String] = []


func _ready():
	GameManager.game_reset.connect(_on_game_manager_reset)


func _on_game_manager_reset():
	alread_played_cutscenes.clear()


func play_cutscene(cutscene_packed_scene: PackedScene) -> void:
	if SettingsManager.skip_cutscenes:
		await Engine.get_main_loop().process_frame
		return
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
