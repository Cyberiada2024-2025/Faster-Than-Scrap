extends Node3D

@export var player: bool = true

@export var aegis_radius: float = 50

@export var path: String = "res://prefabs/npc/bosses/vortex/vortex_boss.tscn::ShaderMaterial_a17kq"

var vortex: ShaderMaterial
var position_param_name: String = "Aegis_Position"
var radius_param_name: String = "Aegis_Radius"


func _ready() -> void:
	vortex = load(path)
	if player:
		await get_tree().process_frame
		reparent(GameManager.player_ship.cockpit)
		position = Vector3(0, -5, 0)

	vortex.set_shader_parameter(radius_param_name, aegis_radius)


func _process(_delta: float) -> void:
	vortex.set_shader_parameter(position_param_name, Vector2(global_position.x, global_position.z))
