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

	self.hide()


func start_slide() -> void:
	started.emit()
	_reveal()


func _reveal() -> void:
	self.show()
	var tween = get_tree().create_tween()
	# Tween color over 1 second
	tween.tween_property(self, "color", black_transparent, 1.0)
	await tween.finished


func _hide() -> void:
	var tween = get_tree().create_tween()
	# Tween color over 1 second
	tween.tween_property(self, "color", black_non_transparent, 1.0)
	await tween.finished
