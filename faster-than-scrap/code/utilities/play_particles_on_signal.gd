class_name PlayParticlesOnSignal
extends Node

@export var particles_to_play: GPUParticles3D


func _ready() -> void:
	particles_to_play.emitting = false


func play() -> void:
	particles_to_play.emitting = true
