class_name ModuleGhost

extends Area3D

var collided_modules: Array[Module]

func _ready():
	body_shape_entered.connect(_on_body_shape_entered)
	body_shape_exited.connect(_on_body_shape_exited)

func _on_body_shape_entered(
	body_rid: RID,
	body: Node3D,
	body_shape_index: int,
	local_shape_index: int):

	collided_modules.append(body.get_child(body_shape_index))

func _on_body_shape_exited(
	body_rid: RID,
	body: Node3D,
	body_shape_index: int,
	local_shape_index: int):

	collided_modules.erase(body.get_child(body_shape_index))
