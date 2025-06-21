extends Node

var brakes_enabled := false
var air_resistance := true:
	set(new_value):
		air_resistance = new_value
		var p = GameManager.player_ship
		# if set before game is launched
		# (assuming these settings should be available during game at all)
		if p != null:
			p.linear_damp = p.linear_damp_value
			p.angular_damp = p.angular_damp_value
var skip_cutscenes := false
