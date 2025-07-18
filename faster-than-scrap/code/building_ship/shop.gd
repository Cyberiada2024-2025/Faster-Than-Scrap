class_name Shop

extends Node3D

## TODO
# prevent generating too many of the same module
# add rarities

## Areas should have negative y coordinate
## otherwise, engine module might not be selectable

@export var ship_builder: ShipBuilder

## set starting cash here
@export_custom(PROPERTY_HINT_NONE, "suffix:$") var starting_bank: int = 0
@export var max_items_count = 10

@export_category("Inventory modules")
## Inventory size X
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var inventory_size_x: float = 0
## Inventory size Y
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var inventory_size_z: float = 15
@export var inventory_columns: int
@export var inventory_rows: int

@export_category("Shop modules")
@export var shop_area: Node3D
## shop size X
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var size_x: float = 0
## shop size Y
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var size_z: float = 15
@export var columns: int
@export var rows: int

@export_category("Visuals")
## display of cash balance
@export var bank_display: RichTextLabel
@export var inventory_limit_display: Label3D

@export var deny_finish: Control

@export var deny_finish_label: Label

@export var repair_button: Button
@export var repair_cost: int = 2
@export var repair_particles: PackedScene = preload(
	"res://prefabs/vfx/particles/repair_particles.tscn"
)

@export var confirm_finish_message_with_unassigned_keys: Control

@export_group("Sounds")
@export var warning_sound: SoundEmitterGlobal

## actual cash balance
var bank: int = 0
var first_frame: bool = true

var areas: Array[Area3D] = []

var all_modules: Array[SceneData]


func _ready() -> void:
	# clear current shop when new map
	MissionManager.map_finished.connect(_clear_shop)
	MissionManager.map_finished.connect(ShopContents.generate_contents)

	GameManager.new_game_state.connect(_on_game_manager_new_game_state)

	_generate_shop()

	_update_repair_button_visibility()


func _on_game_manager_new_game_state(new_state: GameState.State) -> void:
	if new_state == GameState.State.BUILD:
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

		x += shop_area.global_position.x
		z += shop_area.global_position.z

		area.position = Vector3(x, 0, z)
		i += 1


func _generate_inventory() -> void:
	var i = 0
	for obj in InventoryManager.inventory:
		add_child(obj)
		var x: float = (
			inventory_size_x / inventory_columns / 2
			+ i % inventory_columns * inventory_size_x / inventory_columns
			- inventory_size_x / 2
			+ $Inventory.position.x
		)
		var z: float = (
			inventory_size_z / inventory_rows / 2
			+ i / inventory_columns * inventory_size_z / inventory_rows
			- inventory_size_z / 2
			+ $Inventory.position.z
		)
		obj.position = Vector3(x, 0, z)
		obj.get_child(0).position = Vector3(0, 0, 0)
		obj.get_child(0).hide_on_module_camera()
		i += 1
	_display_inventory_number()


func _process(_delta: float) -> void:
	if first_frame:
		first_frame = false
		bank = starting_bank + GameManager.player_ship.money
		_on_bank_change()


func _enter_tree() -> void:
	_generate_inventory()


func _on_bank_change() -> void:
	bank_display.text = (
		"[color=#be601e]"
		+ String.num_int64(bank)
		+ " [img={width=40} color=#be601e]res://art/fonts/cog.png[/img]"
		+ "[/color]"
	)

	# disable repair button if can't afford repair
	repair_button.disabled = (bank < repair_cost) && not DebugMenu.disable_money_checks


func _on_missing_key_confirm_pressed() -> void:
	confirm_finish_message_with_unassigned_keys.visible = false
	_exit_shop()


func _on_missing_key_deny_pressed() -> void:
	confirm_finish_message_with_unassigned_keys.visible = false
	ship_builder.can_interact_with_modules = true


func _on_finish_pressed() -> void:
	if ship_builder.state != ship_builder.State.NONE:
		return

	if DebugMenu.disable_money_checks:
		_exit_shop()

	if bank < 0:
		_show_warning("You cannot leave without paying for modules!")

	elif InventoryManager.if_overflow():
		_show_warning("Your inventory has too many items!")
	else:
		for m in GameManager.player_ship.modules:
			if m.activation_key_saved == KEY_NONE and m.is_activable:
				confirm_finish_message_with_unassigned_keys.visible = true
				ship_builder.can_interact_with_modules = false
				warning_sound.start_playing()
				return
		_exit_shop()


func _show_warning(warning_text: String) -> void:
	deny_finish.visible = true
	ship_builder.can_interact_with_modules = false
	deny_finish_label.text = warning_text
	warning_sound.start_playing()


func _exit_shop() -> void:
	$"../ShipBuilder/SceneLoader".load_fly_ship_scene()
	GameManager.player_ship.money = bank

	repair_button.visible = true  # prevent invisible button when entering the shop
	ship_builder.can_interact_with_modules = true


func _on_confirm_pressed() -> void:
	deny_finish.visible = false
	ship_builder.can_interact_with_modules = true


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
