extends Control


signal toggle_player_collisions


const BTN_PARENT = NodePath(
	"ColorRect/MarginContainer/VBoxContainer2/CenterContainer/VBoxContainer"
)

var enable_invincibility: bool = false:
	get: return enable_invincibility and is_debug

var disable_collisions: bool = false:
	get: return disable_collisions and is_debug

var disable_money_checks: bool = false:
	get: return disable_money_checks and is_debug

var enable_debug_movement: bool = false:
	get: return enable_debug_movement and is_debug

var disable_map_node_checks: bool = false:
	get: return disable_map_node_checks and is_debug

@onready var scene_loader: SceneLoader = $SceneLoader
@onready var is_debug: bool = OS.is_debug_build()

func _ready() -> void:
	visible = false


func _unhandled_input(_event: InputEvent) -> void:
	if not OS.is_debug_build():
		return

	if Input.is_action_just_released("debug_menu"):
		toggle_menu()


func toggle_menu() -> void:
	if not visible:
		GameManager._pause_entities()
		visible = true
		get_node(BTN_PARENT).get_child(0).grab_focus()
	else:
		GameManager._unpause_entities()
		visible = false


func _on_invincibility_pressed() -> void:
	enable_invincibility = not enable_invincibility


func _on_collisions_pressed() -> void:
	disable_collisions = not disable_collisions
	toggle_player_collisions.emit()


func _on_money_checks_pressed() -> void:
	disable_money_checks = not disable_money_checks


func _on_debug_movement() -> void:
	enable_debug_movement = not enable_debug_movement


func _on_map_node_checks_pressed() -> void:
	disable_map_node_checks = not disable_map_node_checks


func _on_map_select_pressed() -> void:
	scene_loader.load_map_selector_scene()
