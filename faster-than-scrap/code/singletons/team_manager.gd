extends Node
class_name TeamManager

enum Team { player, enemy, friend, kill_all }
## shows which teams are aggressive to which teams
## godot doesn't have 2D arrays (WHY), I couldn't find neater way to do this
static var team_hatred_matrix = { Team.player:[Team.enemy, Team.kill_all],
	Team.enemy:[Team.player, Team.friend, Team.kill_all],
	Team.friend:[Team.enemy, Team.kill_all],
	Team.kill_all:[Team.player, Team.enemy, Team.friend]}

static func hate(ship1:Ship, ship2:Ship) -> bool:
	return team_hatred_matrix.get(ship1.team).has(ship2.team)
