class_name BossDead
extends baseTransition


func condition() -> void:
	var boss: Boss = ship_controller.ship
	var act_hp: float = boss.get_health_percentage()

	if act_hp == 0:
		finished.emit(new_state.name)
