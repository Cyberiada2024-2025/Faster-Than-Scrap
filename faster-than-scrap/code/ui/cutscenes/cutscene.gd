class_name Cutscene
extends ColorRect

## Cutscene stops the game to show itself and unpauses the game when finished.
## It consists of slides (each slide is a node), which are children of this object.
## It reveals them one by one.

const BLACK_TRANSPARENT = Color(0, 0, 0, 0)
const BLACK_NON_TRANSPARENT = Color(0, 0, 0, 1)

var slides: Array[Slide]


func _enter_tree() -> void:
	slides.assign(find_children("*", "Slide"))
	color = BLACK_TRANSPARENT
	process_mode = Node.PROCESS_MODE_ALWAYS


func play() -> void:
	await _shine_bright()
	GameManager._pause_entities()

	# play all slides
	for slide in slides:
		await slide.play_slide()

	GameManager._unpause_entities()


## before pausing the game shine the screen bright
func _shine_bright() -> void:  # like a diamond
	var tween = get_tree().create_tween().bind_node(self)
	# Tween color over 1 second
	tween.tween_property(self, "color", BLACK_NON_TRANSPARENT, 1.0)
	await tween.finished
