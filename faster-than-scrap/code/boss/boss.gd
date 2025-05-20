class_name Boss

extends Ship

@export var core: Module

var modules: Array[Module] = []
var max_health: float = 0


func _ready() -> void:
	modules = Module.find_all_modules(self.get_parent_node_3d())
	for module: Module in modules:
		max_health += module.max_hp
		module.destroyed.connect(func(): modules.erase(module))


## returns a number between 0 and 1
func get_health_percentage() -> float:
	var actual_health: float = 0
	for module: Module in modules:
		if module != null:
			actual_health += module.hp
	return actual_health / max_health
