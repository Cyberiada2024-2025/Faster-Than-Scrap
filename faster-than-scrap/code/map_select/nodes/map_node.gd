@tool
class_name MapNode

extends TextureButton

signal clicked(MapNode)

## Map node for map selector. Map node is a circle
## indicating what the player will come across in the future.

@export var next_map_nodes: Array[MapNode] = []
## if the player just finished that node
@export var active: bool = false
## if player came through that node
@export var finished: bool = false

@export var icon: TextureRect
@export var cross: Cross

var selected: bool = false

var angle: float = 0
var arc_count: int = 10


func _ready() -> void:
	if finished:
		cross.show_cross()


func _process(_delta: float) -> void:
	queue_redraw()
	if Engine.is_editor_hint():
		return
	angle += _delta


func _draw() -> void:
	_set_color()
	if selected:
		draw_selected()


## change color according to node type
func _set_color() -> void:
	if active:
		self_modulate = Color.WHITE
		draw_active()
		return
	if finished:
		self_modulate = Color.GRAY

	if icon == null:
		return
	icon.modulate = self_modulate * Color(0.5, 0.5, 0.5)


func draw_active():
	var local_start = get_rect().get_center() - get_rect().position
	var radius = get_rect().size.x / 2

	var delta_angle = PI / arc_count
	for i in range(arc_count):
		var start_angle = 2 * PI * (i) / arc_count

		draw_arc(
			local_start,
			radius,
			start_angle + angle,
			start_angle + delta_angle + angle,
			5,
			Color.GRAY,
			8
		)


func draw_selected():
	var local_start = get_rect().get_center() - get_rect().position
	var min_radius = get_rect().size.x * 2 / 3
	var max_radius = get_rect().size.x

	const FREQUENCY: float = 5
	var t = sin(angle * FREQUENCY) / 2 + 0.5
	var radius = lerp(min_radius, max_radius, t)

	draw_arc(local_start, radius, angle, 2 * PI + angle, 20, Color.GRAY, 4)


func on_click() -> void:
	clicked.emit(self)


func on_hover_enter() -> void:
	pass


func on_hover_leave() -> void:
	pass


func get_description() -> String:
	return ""


func is_after_node(before_node: MapNode) -> bool:
	for node in before_node.next_map_nodes:
		if node == self:
			return true
	return false


func change_scene(_scene_loader: SceneLoader) -> void:
	pass
