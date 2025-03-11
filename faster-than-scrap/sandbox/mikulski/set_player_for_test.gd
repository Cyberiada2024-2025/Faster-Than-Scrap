extends Node

@export var player: PlayerShip
@export var mission: Node
var time: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_ship = player
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time > 1.01 && time < 1000:
		mission.finish_mission()
		time = 100000
		#print_debug(GameManager.player_ship.position)
		#time -= 0.5
	else:
		time += delta

	pass
