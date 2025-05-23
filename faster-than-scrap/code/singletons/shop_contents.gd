extends Node

@export var max_modules_count := 10
var shop_modules: Array[SceneData]


func _ready() -> void:
	generate_contents()


func generate_contents() -> void:
	shop_modules = []
	var rng = RandomNumberGenerator.new()
	for i in range(max_modules_count):
		var module_packed := ModulesList.all_modules[rng.randi_range(
			0, ModulesList.all_modules.size() - 1
		)]
		var module = module_packed.instantiate()
		shop_modules.append(SceneData.new(module.name, module_packed))
