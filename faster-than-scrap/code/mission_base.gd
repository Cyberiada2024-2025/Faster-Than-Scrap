extends Node

enum MissionType { DEFEND, GET_ITEM, ESCAPE }

var is_finished: bool = false
var about: String = ""
var type: MissionType
var difficulty: int

@export var leave_animation: Node
@export var scene_loader: Node


func _ready() -> void:
	pass


func finish_mission() -> void:
	is_finished = true
	leave_animation.leaving_body = GameManager.player_ship
	leave_animation.start_animation(scene_loader.load_map_selector_scene)
