extends Node3D

## modules in the shop. Don't place them in the editor! Place them here!
@export_dir var modules: Array[String] = []
## set starting cash here
@export_custom(PROPERTY_HINT_NONE, "suffix:$") var starting_bank: int = 0
@export var root: Node3D

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

@export var selected_module_prize_display: Label

## actual cash balance
var bank: int = 0
var first_frame: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i: int = 0
	for dir in modules:
		var clone = load(dir)
		var mod = clone.instantiate()
		add_child(mod)
		var x: float = size_x/columns/2 + i%columns*size_x/columns - size_x/2
		var z: float = size_z/rows/2 + i/columns*size_z/rows - size_z/2
		mod.position = Vector3(x, 0, z)
		i += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if first_frame:
		## linter will burn my house down if I don't use delta somewhere in this function
		first_frame = 0 * delta
		first_frame = false
		bank = starting_bank
		_on_bank_change()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Module:
		print("Module Entered")
		var mod: Module = body
		bank += mod.prize
		_on_bank_change()


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Module:
		var mod: Module = body
		bank -= mod.prize
		_on_bank_change()

func _on_bank_change() ->void:
	bank_display.text = String.num(bank) + '$';


func _on_finish_pressed() -> void:
	if(bank < 0):
		deny_finish.visible = true;
	else:
		confirm_finish.visible = true


func _on_confirm_pressed() -> void:
	deny_finish.visible = false


func _on_ship_builder_on_module_select(module: Module) -> void:
	selected_module_prize_display.text = "Selected: " + String.num(module.prize) + '$'
