class_name MapSelector

extends HBoxContainer

@export var layers: Array[MapLayer] = []
@export var active_node: MapNode

@export var label: Label

var selected_node: MapNode = null

func _ready() -> void:
	for layer in layers:
		for node in layer.nodes:
			node.clicked.connect(on_node_clicked)

func on_node_clicked(clicked_node: MapNode) -> void:
	selected_node = clicked_node
	label.text = selected_node.get_description()
