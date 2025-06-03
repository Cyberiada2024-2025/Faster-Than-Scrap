class_name Cutscene
extends ColorRect

## Cutscene stops the game to show itself and unpauses the game when finished.
## It consists of slides (each slide is a node), which are children of this object.
## It reveals them one by one.

signal skip_or_slide_finished

const WHITE_TRANSPARENT = Color(1, 1, 1, 0)
const WHITE_NON_TRANSPARENT = Color(1, 1, 1, 1)

const CIRCLE_OFFSET: float = 50

const MAX_HOLD_TIME: float = 0.5

@export var cutscene_name: String = ""

var slides: Array[Slide]
var skipping: bool = false
var skip_timer: float = 0
var skip_held: bool = false
var skip_circle: CircleProgressBar


func _enter_tree() -> void:
	slides.assign(find_children("*", "Slide"))
	modulate = WHITE_TRANSPARENT
	process_mode = Node.PROCESS_MODE_ALWAYS
	skip_timer = MAX_HOLD_TIME
	_create_skip_circle()


func _create_skip_circle():
	var circle_center: Vector2 = get_rect().size - Vector2.ONE * CIRCLE_OFFSET
	skip_circle = CircleProgressBar.new()
	add_child(skip_circle)
	skip_circle.position = circle_center


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_pressed("Skip Cutscene"):
			skip_held = true
		else:
			skip_held = false
			skip_timer = MAX_HOLD_TIME
			skip_circle.set_percentage(0)


func _process(delta: float) -> void:
	if skip_held:
		skip_timer -= delta
		skip_circle.set_percentage(1.0 - skip_timer / MAX_HOLD_TIME)
	if skip_timer <= 0:
		skipping = true
		skip_circle.set_percentage(1)
		skip_or_slide_finished.emit()


func play() -> void:
	await _darken_screen()
	GameManager._pause_entities()

	# play all slides
	for slide in slides:
		if skipping:
			break
		await _wait_or_skip(slide)

	await _lighten_screen()
	GameManager._unpause_entities()


## before pausing the game darken the screen
func _darken_screen() -> void:  # like a diamond
	var tween = get_tree().create_tween().bind_node(self)
	# Tween color over 1 second
	tween.tween_property(self, "modulate", WHITE_NON_TRANSPARENT, 1.0)
	await tween.finished


## when the cutscene has finished return the camera view
func _lighten_screen() -> void:  # like a diamond
	var tween = get_tree().create_tween().bind_node(self)
	# Tween color over 1 second
	tween.tween_property(self, "modulate", WHITE_TRANSPARENT, 1.0)
	await tween.finished


## Wait for the slide to finish, or the enter hold to skip.
## Addidtionaly turn off the current slide if skipping cutscene
func _wait_or_skip(slide: Slide):
	## wait for slide to finish
	var wait_slide = func(slide_to_wait: Slide):
		# turn off slide with cutscene
		skip_or_slide_finished.connect(func(): slide_to_wait.skip())
		# and normally wait for it to finish
		await slide_to_wait.play_slide()
		skip_or_slide_finished.emit()
	wait_slide.call(slide)

	## Or for enter hold (already in _process and input methods)

	await skip_or_slide_finished
