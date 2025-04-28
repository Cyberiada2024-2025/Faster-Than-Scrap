class_name Slide
extends ColorRect

## Base class for all slides.

signal started
@export var duration: float = 1

const black_transparent = Color(0, 0, 0, 0)
const black_non_transparent = Color(0, 0, 0, 1)


func _enter_tree() -> void:
	color = black_non_transparent
	z_index = 1  # make sure it's in front
	for child: CanvasItem in get_children():
		child.z_index = -1  # make sure it's behind
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()


func play_slide() -> void:
	started.emit()
	await _reveal()
	await get_tree().create_timer(duration, true).timeout
	await _hide_tween()


func _reveal() -> void:
	show()
	var tween := get_tree().create_tween().bind_node(self)
	# Tween color over 1 second
	tween.tween_property(self, "color", black_transparent, 1.0)
	await tween.finished


func _hide_tween() -> void:
	var tween = get_tree().create_tween().bind_node(self)
	# Tween color over 1 second
	tween.tween_property(self, "color", black_non_transparent, 1.0)
	await tween.finished
	hide()
