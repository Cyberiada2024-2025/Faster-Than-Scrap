extends Node

@export var max_modules_count := 10
var shop_modules: Array[PackedScene]


func _ready() -> void:
	generate_contents()


func generate_contents() -> void:
	shop_modules = []
	for i in range(max_modules_count):
		shop_modules.append(
			ModulesList.all_modules[randi_range(0, ModulesList.all_modules.size() - 1)]
		)
