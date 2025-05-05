extends Node3D

@export var max_scale: Vector3 = Vector3(10, 100, 10)
@export var grow_time: float = 1
@export var stay_time: float = 3


func _ready() -> void:
	scale = Vector3.ZERO

	# set grow animation
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", max_scale, grow_time).set_trans(Tween.TRANS_SINE)
	await tween.finished

	# wait stay time
	await get_tree().create_timer(stay_time).timeout

	# shrink
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector3.ZERO, grow_time).set_trans(Tween.TRANS_SINE)
	await tween.finished

	# delete self
	queue_free()
