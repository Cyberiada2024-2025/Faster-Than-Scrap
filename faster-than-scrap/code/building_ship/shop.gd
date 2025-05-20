class_name Shop

extends Node3D

## modules in the shop. Don't place them in the editor! Place them here!
@export_dir var modules: Array[String] = []
## set starting cash here
@export_custom(PROPERTY_HINT_NONE, "suffix:$") var starting_bank: int = 0
#@export var root: Node3D

@export_category("Visuals")
## shop size X
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var size_x: float = 10
## shop size Y
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var size_z: float = 15
## distance X between shop and inventory
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var distance: float = 12
@export var columns: int
@export var rows: int
## display of cash balance
@export var bank_display: Label3D
@export var inventory_limit_display: Label3D

@export var deny_finish: Control
@export var confirm_finish: Control

@export var deny_finish_label: Label
@export var selected_module_prize_display: Label

## actual cash balance
var bank: int = 0
var first_frame: bool = true

var areas: Array[Area3D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i: int = 0
	for dir in modules:
		var clone = load(dir)
		var mod = clone.instantiate()
		var area = Area3D.new()
		add_child(area)
		area.add_child(mod)
		mod.position = Vector3.ZERO
		var x: float = size_x / columns / 2 + i % columns * size_x / columns - size_x / 2
		var z: float = size_z / rows / 2 + i / columns * size_z / rows - size_z / 2
		area.position = Vector3(x, 0, z)
		i += 1
	i = 0
	for obj in InventoryManager.inventory:
		add_child(obj)
		var x: float = size_x / columns / 2 + i % columns * size_x / columns - size_x / 2 + distance
		var z: float = size_z / rows / 2 + i / columns * size_z / rows - size_z / 2
		obj.position = Vector3(x, 0, z)
		obj.get_child(0).position = Vector3(0, 0, 0)
		i += 1
	_display_inventory_number()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if first_frame:
		## linter will burn my house down if I don't use delta somewhere in this function
		first_frame = 0 * delta
		first_frame = false
		bank = starting_bank
		_on_bank_change()


func _on_bank_change() -> void:
	bank_display.text = String.num(bank) + "$"


func _on_finish_pressed() -> void:
	if bank < 0:
		deny_finish.visible = true
		deny_finish_label.text = "You cannot leave without paying for modules!"
	elif InventoryManager.if_overflow():
		deny_finish.visible = true
		deny_finish_label.text = "Your inventory has too many items!"
	else:
		confirm_finish.visible = true


func _on_confirm_pressed() -> void:
	deny_finish.visible = false


func _on_ship_builder_on_module_select(module: Module) -> void:
	selected_module_prize_display.text = "Selected: " + String.num(module.prize) + "$"


func _on_area_3d_body_entered(body: Node3D) -> void:
	for child in body.get_children():
		if child is Module:
			var mod: Module = child
			bank += mod.prize
			_on_bank_change()
			if !areas.has(body):
				areas.push_back(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if areas.has(body):
		for child in body.get_children():
			if child is Module:
				var mod: Module = child
				bank -= mod.prize
				_on_bank_change()
				areas.remove_at(areas.find(body))


func _on_area_3d_area_entered(area: Area3D) -> void:
	_on_area_3d_body_entered(area)


func _on_area_3d_area_exited(area: Area3D) -> void:
	_on_area_3d_body_exited(area)


func _on_inventory_entered(body: Area3D) -> void:
	if InventoryManager.add_item(body):
		_display_inventory_number()


func _on_inventory_exited(body: Area3D) -> void:
	if InventoryManager.remove_item(body):
		_display_inventory_number()


func _display_inventory_number() -> void:
	var current_num = InventoryManager.get_item_num()
	var max_num = InventoryManager.get_max_item_num()
	if current_num > max_num:
		inventory_limit_display.modulate = Color("red")
	else:
		inventory_limit_display.modulate = Color(0.1, 1, 0)
	inventory_limit_display.text = (
		String.num_int64(current_num) + "\\" + String.num_int64(max_num)
	)
