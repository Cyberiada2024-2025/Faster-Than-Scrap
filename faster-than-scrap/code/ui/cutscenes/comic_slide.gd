class_name ComicSlide
extends Slide

@export var rects: Array[ColorRect] = []

var time_per_comic: float


func _enter_tree() -> void:
	super()
	time_per_comic = duration / rects.size()
	for rect: ColorRect in rects:
		rect.color = black_non_transparent


func play_slide() -> void:
	started.emit()
	await _reveal()
	for rect: ColorRect in rects:
		_reveal_comic_part(rect)
		await _wait_or_skip(time_per_comic)
	await _hide_tween()


func _reveal_comic_part(rect: ColorRect) -> void:
	show()
	var tween := get_tree().create_tween().bind_node(self)
	# Tween color over 1 second
	tween.tween_property(rect, "color", black_transparent, time_per_comic / 2)
	await tween.finished
