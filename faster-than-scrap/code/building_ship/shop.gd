class_name Shop

extends Node3D

## TODO
# prevent generating too many of the same module
# add rarities

## Areas should have negative y coordinate
## otherwise, engine module might not be selectable

## set starting cash here
@export_custom(PROPERTY_HINT_NONE, "suffix:$") var starting_bank: int = 0
@export var max_items_count = 10

@export_category("Visuals")
## shop size X
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var size_x: float = 0
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
@export var selected_module_display: RichTextLabel
@export var selected_module_description: RichTextLabel

@export var repair_button: Button
@export var repair_cost: int = 2
@export var repair_particles: PackedScene = preload(
	"res://prefabs/vfx/particles/base_projectile_hit_particles.tscn"
)

@export var confirm_finish_message_with_unusigned_keys: Control

## actual cash balance
var bank: int = 0
var first_frame: bool = true

var areas: Array[Area3D] = []

var all_modules: Array[SceneData]


func _ready() -> void:
	# clear current shop when new map
	MissionManager.map_finished.connect(_clear_shop)
	MissionManager.map_finished.connect(ShopContents.generate_contents)

	_generate_shop()

	_update_repair_button_visibility()


func _clear_shop() -> void:
	MapGenerator._saved_scene = null  # so scene loader will create new shop
	queue_free()
	#should left items be moved to inventory?


func _repair_modules() -> void:
	var modules = _get_all_shop_and_ship_modules()

	for module in modules:
		if module.hp < module.max_hp and repair_particles != null:
			var particles: Node3D = repair_particles.instantiate()
			particles.global_position = module.global_position
			get_tree().current_scene.add_child(particles)
		_heal_module_by_fraction(module, 0.25)

	bank -= repair_cost
	_on_bank_change()
	_update_repair_button_visibility()


## Heals module by [code]health_fraction * max_hp[/code].
func _heal_module_by_fraction(module: Module, health_fraction: float) -> void:
	module.heal(module.max_hp * health_fraction)


## Heals module by heal_value.
func _heal_module(module: Module, heal_value: float) -> void:
	module.heal(heal_value)


## Hides the repair button if there are no modules that can be repaired
func _update_repair_button_visibility() -> void:
	var modules = _get_all_shop_and_ship_modules()
	repair_button.visible = false
	for module in modules:
		if module.hp < module.max_hp:
			repair_button.visible = true
			return


func _get_all_shop_and_ship_modules() -> Array[Module]:
	var shop_modules = Module.find_all_modules(get_tree().current_scene)
	var ship_modules = Module.find_all_modules(GameManager.player_ship)
	return shop_modules + ship_modules


func _generate_shop() -> void:
	all_modules = ShopContents.shop_modules
	var i = 0
	for module_data in all_modules:
		var module = module_data.packed_scene.instantiate()
		var area = Area3D.new()
		add_child(area)
		area.add_child(module)
		module.position = Vector3.ZERO
		module.hide_on_module_camera()
		var x: float = size_x / columns / 2 + i % columns * size_x / columns - size_x / 2
		var z: float = size_z / rows / 2 + i / columns * size_z / rows - size_z / 2
		area.position = Vector3(x, 0, z)
		i += 1


func _generate_inventory() -> void:
	var i = 0
	for obj in InventoryManager.inventory:
		add_child(obj)
		var x: float = size_x / columns / 2 + i % columns * size_x / columns - size_x / 2
		var z: float = (
			size_z / rows / 2 + i / columns * size_z / rows - size_z / 2 + $Inventory.position.z
		)
		obj.position = Vector3(x, 0, z)
		obj.get_child(0).position = Vector3(0, 0, 0)
		obj.hide_on_module_camera()
		i += 1
	_display_inventory_number()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if first_frame:
		## linter will burn my house down if I don't use delta somewhere in this function
		first_frame = 0 * delta
		first_frame = false
		bank = starting_bank + GameManager.player_ship.money
		_on_bank_change()


func _enter_tree() -> void:
	_generate_inventory()


func _on_bank_change() -> void:
	bank_display.text = String.num_int64(bank) + "$"

	# disable repair button if can't afford repair
	repair_button.disabled = (bank < repair_cost)


func _on_missing_key_confirm_pressed() -> void:
	confirm_finish_message_with_unusigned_keys.visible = false
	_exit_shop()


func _on_missing_key_deny_pressed() -> void:
	confirm_finish_message_with_unusigned_keys.visible = false


func _on_finish_pressed() -> void:
	if DebugMenu.disable_money_checks:
		_exit_shop()

	if bank < 0:
		deny_finish.visible = true
		deny_finish_label.text = "You cannot leave without paying for modules!"
	elif InventoryManager.if_overflow():
		deny_finish.visible = true
		deny_finish_label.text = "Your inventory has too many items!"
	else:
		for m in GameManager.player_ship.modules:
			if m.activation_key_saved == KEY_NONE and m.is_activable:
				confirm_finish_message_with_unusigned_keys.visible = true
				return
		_exit_shop()


func _exit_shop() -> void:
	#confirm_finish.visible = true
	$"../ShipBuilder/SceneLoader".load_fly_ship_scene()
	GameManager.player_ship.money = bank

	repair_button.visible = true  # prevent invisible button when entering the shop


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


func _on_inventory_entered(body: Area3D) -> void:
	if InventoryManager.add_item(body):
		_display_inventory_number()


func _on_inventory_exited(body: Area3D) -> void:
	if InventoryManager.remove_item(body):
		_display_inventory_number()


func _display_inventory_number() -> void:
	if inventory_limit_display == null:
		return

	var current_num = InventoryManager.get_item_num()
	var max_num = InventoryManager.get_max_item_num()
	if current_num > max_num:
		inventory_limit_display.modulate = Color("red")
	else:
		inventory_limit_display.modulate = Color(0.1, 1, 0)
	inventory_limit_display.text = (
		String.num_int64(current_num) + "\\" + String.num_int64(max_num)
	)


func _on_module_attached(module: Module) -> void:
	bank -= module.prize
	_on_bank_change()


func _on_ship_builder_on_module_detach(module: Module) -> void:
	bank += module.prize
	_on_bank_change()
