class_name Boss

extends Ship

@export var core: Module

var modules: Array[Module] = []
var max_health: float = 0


func _ready() -> void:
	modules = Module.find_all_modules(self.get_parent_node_3d())
	for module: Module in modules:
		max_health += module.hp


## returns a number between 0 and 1
func get_health_percentage() -> float:
	var actual_health: float = 0
	var index = 0
	for module: Module in modules:
		if module != null:
			actual_health += module.hp
		else:
			modules.remove_at(index)  # erase doesn't seem to work :/
		index += 1
	return actual_health / max_health
