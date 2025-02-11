class_name ResourceBar

extends Node

## Current maximum value
@export var max_value: float = 100

@export_group('Animation')
## Speed of decrease for the bar that shows how much energy was lost
@export_custom(PROPERTY_HINT_NONE, "suffix:value/sec") var change_speed: float
## How long do we wait before decreasing bar that shows how much value was lost
@export_custom(PROPERTY_HINT_NONE, "suffix:sec") var change_wait: float
## name of the "warning no value" animation
@export var warning_anim: String = "warning"

@export_group("Scaling")
## max value of the shortest possible bar
@export var base_max_value: float
## max value of the longest possible bar
@export var max_max_value: float

@export_subgroup("overlay")
## decorative overlay height for shortest possible bar
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var overlay_base_height: int
## decorative overlay height for longest possible bar
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var overlay_max_height: int
## decorative overlay y component of position for shortest possible bar

@export_subgroup("bars")
## value bars height for shortest possible bar
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var bar_base_height: int
## value bars height for longest possible bar
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var bar_max_height: int
## value bars y component of position for shortest possible bar
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var bar_base_pos: int
## value bars y component of position for longest possible bar
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var bar_max_pos: int

@export_group('Nodes')
## main bar
@export var bar: ProgressBar
## bar showing how much value was lost
@export var bar1: ProgressBar
## decorative overlay
@export var overlay: Control
## text display of numerical value
@export var numbers: Label
## animator used for "warning no value" animation
@export var animator: AnimationPlayer

#current value main bar
var value: float = 1
#current value of bar showing how much value was lost
var value1 = 1
# timer counting down waiting time
var wait_timer: float = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(wait_timer > 0):
		wait_timer -= delta
	elif(value1 > value):
		value1 -= change_speed * delta
		bar1.value = value1

func _change_value(input: float) -> void:
	wait_timer = change_wait
	value = input
	bar.value = value

	var temp: int = int(value)
	var str: String = ""
	for i in 4:
		str += String.num(temp % 10)
		temp /= 10
	numbers.text = str.reverse()

	if(value > value1):
		value1 = value
		bar1.value = value1
		wait_timer = 0

func _on_warning() -> void:
	animator.play(warning_anim)

func _on_max_change(new_max_value: float) -> void:
	max_value = new_max_value
	value = min(value, max_value)
	value1 = min(value, max_value)
	bar.max_value = max_value
	bar1.max_value = max_value

	# t = 0 for max_value = base_max_value and t = 1 for max_value = max_max_value
	# t scale linearly between these two
	var t: float = (max_value - base_max_value)/(max_max_value - base_max_value)
	overlay.size.y = (overlay_max_height - overlay_base_height) * t + overlay_base_height
	bar1.position.y = (bar_max_pos - bar_base_pos) * t + bar_base_pos
	bar1.size.y = (bar_max_height - bar_base_height) * t + bar_base_height
	bar.size.y = (bar_max_height - bar_base_height) * t + bar_base_height
