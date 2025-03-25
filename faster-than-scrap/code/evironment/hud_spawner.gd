class_name HudSpawner

extends Node


func _ready() -> void:
	var hud_scene = load("res://prefabs/hud.tscn")
	var hud = hud_scene.instantiate()
	add_child(hud)
