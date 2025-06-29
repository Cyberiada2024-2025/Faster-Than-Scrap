@tool
extends Control

## set the dimensions of a module to allow hovering
@export var hover_size: Vector2 = Vector2.ZERO

@onready var parent_module: Module = get_parent()


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	GameManager.new_game_state.connect(_on_game_change_state)
	pivot_offset = size / 2
	#hide()
	#set_process(false)
	$ToolView.queue_free()  #remove Tool view
	$DebugView.queue_free()  #remove Debug view


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		$ToolView.scale.x = hover_size.x / 2
		$ToolView.scale.z = hover_size.y / 2
		return
	var world_pos = parent_module.global_transform.origin
	var world_corner_pos = world_pos + Vector3(hover_size.x, 0, -hover_size.y)

	var camera: Camera3D = get_viewport().get_camera_3d()
	var screen_pos = camera.unproject_position(world_pos)
	var screen_corner_pos = camera.unproject_position(world_corner_pos)

	size.x = abs(screen_corner_pos.x - screen_pos.x)
	size.y = abs(screen_corner_pos.y - screen_pos.y)

	pivot_offset = size / 2
	position = screen_pos - size / 2
	rotation = -parent_module.global_rotation.y


func _on_game_change_state(new_state: GameState.State) -> void:
	if new_state == GameState.State.BUILD:
		show()
		set_process(true)
	else:
		hide()
		set_process(false)


func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip = preload("res://prefabs/ui/module_tooltip.tscn").instantiate()
	tooltip.config(parent_module)
	print("TOOLTIP")
	return tooltip
