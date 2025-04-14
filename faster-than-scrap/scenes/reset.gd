extends Button


func _pressed() -> void:
	GameManager.player_ship.queue_free()
	GameManager.player_ship = preload("res://prefabs/ships/flyable_ship.tscn").instantiate()
	MapGenerator.reset()
	GameManager.set_game_state(GameState.State.BUILD)
