extends Control


signal toggle_player_collisions


const BTN_PARENT = NodePath(
	"ColorRect/MarginContainer/VBoxContainer2/CenterContainer/VBoxContainer"
)

var invincibility: bool = false
var collisions: bool = true
var money_checks: bool = true
var debug_movement: bool = false
var map_node_checks: bool = true


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
	invincibility = not invincibility


func _on_collisions_pressed() -> void:
	collisions = not collisions
	toggle_player_collisions.emit()


func _on_money_checks_pressed() -> void:
	money_checks = not money_checks


func _on_debug_movement() -> void:
	debug_movement = not debug_movement


func _on_map_node_checks_pressed() -> void:
	map_node_checks = not map_node_checks
