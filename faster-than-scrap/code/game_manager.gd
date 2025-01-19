class_name GameManager

extends Node

@export var game_state :GameState.State = GameState.State.FLY
@export var ship: PlayerShip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _set_game_state(new_state: GameState.State) -> void:
	game_state=new_state
	ship.on_game_change_state(new_state)

	# future logic for changing state
	match new_state:
		GameState.State.FLY:
			pass
		GameState.State.PAUSE:
			pass
		GameState.State.CUTSCENE:
			pass
		GameState.State.BUILD:
			pass
		GameState.State.MAIN_MENU:
			pass
