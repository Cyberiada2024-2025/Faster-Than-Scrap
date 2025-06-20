class_name MapSelector

extends HBoxContainer

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
	label.text = selected_node.get_description()


func on_leave_button_clicked() -> void:
	if selected_node != null and selected_node.is_after_node(active_node):
		MapGenerator.set_node(selected_node)
		MapSaver.save_map()
		selected_node.change_scene(scene_loader)
