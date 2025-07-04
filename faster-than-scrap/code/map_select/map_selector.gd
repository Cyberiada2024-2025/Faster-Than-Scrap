class_name MapSelector

extends HBoxContainer

signal on_node_selected(invalid: bool)

@export var active_node: MapNode

@export var label: RichTextLabel
@export var scene_loader: SceneLoader

var layers: Array[MapLayer] = []
var selected_node: MapNode = null


func _ready() -> void:
	layers.assign(find_children("*", "MapLayer"))

	for layer in layers:
		for node in layer.nodes:
			node.clicked.connect(on_node_clicked)


func update_self() -> void:
	if selected_node != null:
		active_node.finished = true
		active_node.active = false

		active_node = selected_node
		active_node.active = true


func on_node_clicked(clicked_node: MapNode) -> void:
	if selected_node != null:
		selected_node.selected = false
	selected_node = clicked_node
	selected_node.selected = true

	var is_valid = _valid_node(clicked_node)
	if is_valid:
		label.text = selected_node.get_description()
	else:
		label.text = ""

	on_node_selected.emit(not is_valid)


## return whether given node is selectable as next mission
func _valid_node(target_node: MapNode) -> bool:
	var previous_nodes = _get_previous_nodes(target_node)

	# find if any of nodes is active
	for node in previous_nodes:
		if node.active:
			return true

	return false


func _get_previous_nodes(target_node: MapNode) -> Array[MapNode]:
	# find layer where target node is
	var target_layer: MapLayer
	for layer: MapLayer in layers:
		if layer.nodes.has(target_node):
			target_layer = layer
			break

	# find all previous nodes connected to target node
	var previous_layer = layers[layers.find(target_layer) - 1]
	var previous_nodes: Array[MapNode] = []
	for node: MapNode in previous_layer.nodes:
		if node.next_map_nodes.has(target_node):
			previous_nodes.append(node)
	return previous_nodes


func on_leave_button_clicked() -> void:
	if selected_node == null:
		return

	if selected_node.is_after_node(active_node) or DebugMenu.disable_map_node_checks:
		MapGenerator.set_node(selected_node)
		MapSaver.save_map()
		selected_node.change_scene(scene_loader)
