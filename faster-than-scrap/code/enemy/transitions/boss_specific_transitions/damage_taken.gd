extends baseTransition

# signal is emited each time health percentage was taken

@export_range(0, 1) var health_percentage_taken: float = 0.1
@export var damage_memory: DamageMemory


## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_previous_state_path: String, _data := {}) -> void:
	var boss: Boss = ship_controller.ship
	if damage_memory.hp == INF:
		damage_memory.hp = boss.get_health_percentage()


func condition() -> void:
	var boss: Boss = ship_controller.ship
	var act_hp: float = boss.get_health_percentage()

	if act_hp < damage_memory.hp - health_percentage_taken:
		damage_memory.hp -= health_percentage_taken
		finished.emit(new_state.name)
