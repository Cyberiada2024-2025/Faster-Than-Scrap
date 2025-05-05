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
		rect.color = Cutscene.WHITE_TRANSPARENT
		rect.modulate = Cutscene.WHITE_TRANSPARENT


## override to only skip single panel on enter press
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("Skip Cutscene") and playing:
			skip_or_timer.emit()


func play_slide() -> void:
	playing = true
	started.emit()
	await _reveal()
	for rect: ColorRect in rects:
		if skipped:
			break
		_reveal_comic_part(rect)
		await _wait_or_skip(time_per_comic)
	await _hide_tween()


func _reveal_comic_part(rect: ColorRect) -> void:
	show()
	var tween := get_tree().create_tween().bind_node(self)
	# Tween color over 1 second
	tween.tween_property(
		rect, "modulate", Cutscene.WHITE_NON_TRANSPARENT, time_per_comic * reveal_time
	)
	await tween.finished
