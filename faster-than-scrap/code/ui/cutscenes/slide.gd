class_name Slide
extends ColorRect

## Base class for all slides.

signal started
signal skip_or_timer

@export var duration: float = 1

var skipped: bool = false
var playing: bool = false


func _enter_tree() -> void:
	modulate = Cutscene.WHITE_TRANSPARENT
	#process_mode = Node.PROCESS_MODE_ALWAYS
	hide()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("Skip Cutscene") and playing:
			skip()


func skip():
	skipped = true
	skip_or_timer.emit()


func play_slide() -> void:
	playing = true
	started.emit()
	await _reveal()
	if not skipped:
		await _wait_or_skip(duration)
	await _hide_tween()


func _wait_or_skip(wait_time: float):
	# dictionary instead of bool, because it will be passed by reference
	var state := {"skipped": false}
	## default timer
	get_tree().create_timer(wait_time, true).timeout.connect(
		func():
			if not state.skipped:
				skip_or_timer.emit()
			else:
				print("ALREADY")
	)
	## emiting enter is in input

	await skip_or_timer
	state.skipped = true


func _get_tween_time():
	if skipped:
		return 0.25
	return 1


func _reveal() -> void:
	show()
	var tween := get_tree().create_tween().bind_node(self)
	# Tween color over 1 second
	tween.tween_property(self, "modulate", Cutscene.WHITE_NON_TRANSPARENT, _get_tween_time())
	await tween.finished


func _hide_tween() -> void:
	var tween = get_tree().create_tween().bind_node(self)
	# Tween color over 1 second
	tween.tween_property(self, "modulate", Cutscene.WHITE_TRANSPARENT, _get_tween_time())
	await tween.finished
	hide()
