extends HSlider


func _ready() -> void:
	value_changed.connect(_scale_changed)


func _scale_changed(value: float) -> void:
	get_viewport().scaling_3d_scale = maxf(value, 0.000001)
