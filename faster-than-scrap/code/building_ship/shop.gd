class_name Shop

extends Node3D

## TODO
# prevent generating too many of the same module
# add rarities


## modules in the shop. Don't place them in the editor! Place them here!
#@export_dir var modules: Array[String] = []
var all_modules: Array[SceneData]
## set starting cash here
@export_custom(PROPERTY_HINT_NONE, "suffix:$") var starting_bank: int = 0
@export var max_items_count = 10
#@export var root: Node3D

@export_category("Visuals")
## shop size X
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var size_x: float = 10
## shop size Y
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var size_z: float = 15
@export var columns: int
@export var rows: int
## display of cash balance
@export var bank_display: Label3D

@export var deny_finish: Control
@export var confirm_finish: Control

@export var selected_module_display: RichTextLabel
@export var selected_module_description: RichTextLabel

## actual cash balance
var bank: int = 0
var first_frame: bool = true

var areas: Array[Area3D] = []
var loaded := false
#TODO turn into singleton? so it gets ready only once


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MissionManager.map_finished.connect(ShopContents.generate_contents)
	_generate_shop()


func _generate_shop() -> void:
	all_modules = ShopContents.shop_modules
	var i = 0
	for moduleData in all_modules:
		var module = moduleData.packed_scene.instantiate()
		var area = Area3D.new()
		add_child(area)
		area.add_child(module)
		module.position = Vector3.ZERO
		var x: float = size_x / columns / 2 + i % columns * size_x / columns - size_x / 2
		var z: float = size_z / rows / 2 + i / columns * size_z / rows - size_z / 2
		area.position = Vector3(x, 0, z)
		i += 1
	await Engine.get_main_loop().process_frame
	loaded = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if first_frame:
		## linter will burn my house down if I don't use delta somewhere in this function
		first_frame = 0 * delta
		first_frame = false
		bank = starting_bank
		_on_bank_change()


func _on_bank_change() -> void:
	bank_display.text = String.num_int64(bank) + "$"


func _on_finish_pressed() -> void:
	if bank < 0:
		deny_finish.visible = true
	else:
		confirm_finish.visible = true


func _on_confirm_pressed() -> void:
	deny_finish.visible = false


func _on_ship_builder_on_module_select(module: Module) -> void:
	if module == null:
		# hide description, because mouse is not over module
		selected_module_display.text = ""
		selected_module_display.text += ""
		selected_module_description.text = ""
		return
	selected_module_display.text = "[b]" + module.module_name + ":[/b] "
	selected_module_display.text += String.num_int64(module.prize) + "$"

	selected_module_description.text = module.description


func _on_area_3d_body_entered(body: Node3D) -> void:
	for child in body.get_children():
		if child is Module:
			var mod: Module = child
			bank += mod.prize

			#if loaded:
			#for i in all_modules:
			#if i.name == mod.name:
			#ShopContents.shop_modules.erase(i)  # it clears at start everything
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


func _on_module_attached(module: Module) -> void:
	_on_area_3d_body_exited(module.get_parent())
