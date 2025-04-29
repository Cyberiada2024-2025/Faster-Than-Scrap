class_name ComicSlide
extends Slide

@export var rects: Array[ColorRect] = []
## how long  a comic part will be revealed
@export_range(0, 1) var reveal_time: float
var time_per_comic: float


func _enter_tree() -> void:
	super()
	time_per_comic = duration / rects.size()
	for rect: ColorRect in rects:
		rect.color = BLACK_NON_TRANSPARENT


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
	tween.tween_property(rect, "color", BLACK_TRANSPARENT, time_per_comic * reveal_time)
	await tween.finished
