class_name HudSpawner

extends Node

static var spawn_hud = false

var hud_scene = load("res://prefabs/ui/hud.tscn")
var hud: Hud


func _ready() -> void:
	if spawn_hud:
		_spawn()


func _process(_delta: float) -> void:
	if spawn_hud:
		_spawn()


func _spawn() -> void:
	if hud != null:
		hud.queue_free()
	hud = hud_scene.instantiate()
	add_child(hud)
	spawn_hud = false
