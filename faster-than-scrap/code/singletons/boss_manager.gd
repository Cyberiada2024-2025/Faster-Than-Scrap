extends Node

## Simple singleton for passing info between map_select and boss_spawner,
## to tell which bosses should be spawn.

var bosses_to_spawn: Array[PackedScene] = []
var is_miniboss = false
