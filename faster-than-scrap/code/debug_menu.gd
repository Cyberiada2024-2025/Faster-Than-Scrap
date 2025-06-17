extends Control

const BTN_PARENT = NodePath(
	"ColorRect/MarginContainer/VBoxContainer2/CenterContainer/VBoxContainer"
)

signal toggle_player_collisions

var invincibility: bool = false
var collisions: bool = true


func _ready() -> void:
	visible = false


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_released("debug_menu") and OS.is_debug_build():
		print("Working!")
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
