extends Node3D

signal after_finished

@export_category("Animation")
@export var leaving_body: Node3D
@export_group("Curve")
@export var rotation_curve: Curve
@export var scale_curve: Curve
@export_group("Animation Fragments Times")
@export var rotation_time: float = 1.0

var fragment_time: float = 0
var total_time: float = 0
var is_started: bool = false


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if is_started:
		fragment_time += delta
		total_time += delta


func startAnimation() -> void:
	is_started = true
