class_name SceneData
extends Resource

var name: String
var packed_scene: PackedScene


func _init(_name: String, _scene: PackedScene):
	name = _name
	packed_scene = _scene
