class_name ResourceBar

extends Node

@export var max_value: float = 100

@export_group('Animation')
@export var change_speed: float
@export var change_wait: float

@export_group("Scaling")
@export var min_max_value: float
@export var max_max_value: float
@export_subgroup("overlay")
@export var overlay_base_height: int
@export var overlay_max_height: int
@export var overlay_base_pos: int
@export var overlay_max_pos: int
@export_subgroup("bars")
@export var bar_base_height: int
@export var bar_max_height: int
@export var bar_base_pos: int
@export var bar_max_pos: int

@export_group('Nodes')
@export var bar: ProgressBar
@export var bar1: ProgressBar
@export var overlay: Control
@export var numbers: Label
@export var animator: AnimationPlayer

var value: float = 1
var value1 = 1
var wait_timer: float = 0
var warning_anim: String = "warning"
var change: float = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(wait_timer)
	if(wait_timer > 0):
		wait_timer -= delta
	elif(value1 > value):
		value1 -= change * delta
		bar1.value = value1
	pass
	
func _change_value(input: float) -> void:
	if(wait_timer <= 0 && value1 <= value):
		wait_timer = change_wait
	value = input
	bar.value = value
	
	var temp: int = (int)(value)
	var str: String = ""
	for i in 4:
		str += String.num(temp % 10)
		temp /= 10
	numbers.text = str.reverse()
	
	if(value > value1):
		value1 = value
		bar1.value = value1
		wait_timer = 0
	pass
	
func _on_warning() -> void:
	animator.play(warning_anim)
	
func _on_max_change(new_max_value: float) -> void:
	max_value = new_max_value
	value = min(value, max_value)
	value1 = min(value, max_value)
	bar.max_value = max_value
	bar1.max_value = max_value
	change = max_value / change_speed

	var t: float = (max_value - min_max_value)/(max_max_value - min_max_value)
	overlay.position.y = (overlay_max_pos - overlay_base_pos) * t + overlay_base_pos
	overlay.size.y = (overlay_max_height - overlay_base_height) * t + overlay_base_height
	bar1.position.y = (bar_max_pos - bar_base_pos) * t + bar_base_pos
	bar1.size.y = (bar_max_height - bar_base_height) * t + bar_base_height
	bar.size.y = (bar_max_height - bar_base_height) * t + bar_base_height
