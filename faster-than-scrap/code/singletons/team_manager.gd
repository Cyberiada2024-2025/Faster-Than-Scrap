class_name TeamManager
extends Node

enum Team { PLAYER, ENEMY, FRIEND, KILL_ALL }
## shows which teams are aggressive to which teams
## godot doesn't have 2D arrays (WHY), I couldn't find neater way to do this
static var team_hatred_matrix = { Team.PLAYER:[Team.ENEMY, Team.KILL_ALL],
	Team.ENEMY:[Team.PLAYER, Team.FRIEND, Team.KILL_ALL],
	Team.FRIEND:[Team.ENEMY, Team.KILL_ALL],
	Team.KILL_ALL:[Team.PLAYER, Team.ENEMY, Team.FRIEND]}

static func hate(ship1:Ship, ship2:Ship) -> bool:
	return team_hatred_matrix.get(ship1.team).has(ship2.team)
