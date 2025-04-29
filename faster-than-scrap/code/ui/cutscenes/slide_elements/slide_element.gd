class_name SlideElement
extends Control

## curve determining the speed over time
@export var element_speed: Curve

var slide_on := false
var time_counter: float = 0


func _ready() -> void:
	var slide: Slide = _find_parent_slide(self)
	# wait until slide has started
	slide.started.connect(func(): slide_on = true)


func _find_parent_slide(control: Control) -> Slide:
	var parent = control.get_parent_control()
	if parent == null:
		return null
	if parent is Slide:
		return parent
	return _find_parent_slide(parent)


func _process(delta: float) -> void:
	if slide_on:
		if element_speed != null:
			_slide_process(element_speed.sample(time_counter) * delta)
		else:
			_slide_process(delta)
		time_counter += delta


# virtual function to override the slide element behaviour
func _slide_process(_delta: float) -> void:
	pass
