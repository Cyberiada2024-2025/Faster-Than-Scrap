extends Node3D

var path: String = "res://art/materials/vfx/Vortex.tres"
var vortex: ShaderMaterial
var param_name: String = "Aegis_Position"

func _ready() -> void:
	vortex = load(path)

func _process(_delta: float) -> void:
	vortex.set_shader_parameter(param_name, Vector2(global_position.x, global_position.z))
