class_name GameManager

extends Node

@export var game_state :GameState.state = GameState.state.FLY
@export var ship: Ship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _set_game_state(new_state: GameState.state) -> void:
	game_state=new_state
	ship.on_game_change_state(new_state)
	
	# future logic for changing state
	match new_state:
		GameState.state.FLY:
			pass
		GameState.state.PAUSE: 
			pass
		GameState.state.CUTSCENE: 
			pass
		GameState.state.BUILD: 
			pass
		GameState.state.MAIN_MENU: 
			pass
