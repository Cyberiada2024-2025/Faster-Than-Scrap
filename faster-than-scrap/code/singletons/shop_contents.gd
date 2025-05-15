extends Node

@export var max_modules_count := 10
var shop_modules: Array[SceneData]


func _ready() -> void:
	generate_contents()


#func remove_from_shop() -> void:
#PackedScene.


func generate_contents() -> void:
	shop_modules = []
	for i in range(max_modules_count):
		var modulePacked := ModulesList.all_modules[randi_range(
			0, ModulesList.all_modules.size() - 1
		)]
		var module = modulePacked.instantiate()
		shop_modules.append(SceneData.new(module.name, modulePacked))
