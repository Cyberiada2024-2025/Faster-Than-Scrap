extends Node

@export var meshes: Array[MeshInstance3D]
@export var min_param: float = 0.3
@export var max_param: float = 0.6
@export var param_name: String = "Rust_Amount"

var materials: Array[ShaderMaterial]

func _ready() -> void:
	for mesh in meshes:
		materials.append(mesh.material_override)
	_on_ship_damage(INF)

func _on_ship_damage(hp_percent) -> void:
	var param: float = 1 - hp_percent;
	param = param * (max_param - min_param) + min_param
	for mat in materials:
		mat.set_shader_parameter(param_name, param)
