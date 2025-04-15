extends Node

var inventory: Array[Area3D] = []


func change_inventory() -> void:
	for i in range(inventory.size()):
		var item = inventory[i]
		var area = Area3D.new()
		item.get_child(0).reparent(area, false)
		inventory[i] = area


func add_item(body: Area3D) -> void:
	if !inventory.has(body):
		inventory.push_back(body)


func remove_item(body: Area3D) -> void:
	if inventory.has(body):
		inventory.remove_at(inventory.find(body))
