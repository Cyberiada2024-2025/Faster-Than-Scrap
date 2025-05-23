extends Node

var inventory: Array[Area3D] = []
var max_items = 8
var item_number = 0


func save_inventory() -> void:
	for i in range(inventory.size()):
		var item = inventory[i]
		var area = Area3D.new()
		item.get_child(0).reparent(area, false)
		inventory[i] = area


func add_item(body: Area3D) -> bool:
	if !inventory.has(body):
		inventory.push_back(body)
		item_number += 1
		return true
	return false


func remove_item(body: Area3D) -> bool:
	if inventory.has(body):
		inventory.remove_at(inventory.find(body))
		item_number -= 1
		return true
	return false


func get_item_num() -> int:
	return item_number


func get_max_item_num() -> int:
	return max_items


func if_overflow() -> bool:
	return max_items < item_number
