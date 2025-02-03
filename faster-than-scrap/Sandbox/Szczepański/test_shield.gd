extends Node

@export var shield: ShieldModule

var wait = 0.5
var timer = 0.0

func _process(delta: float) -> void:
	timer -= delta
	if(timer <= 0 && Input.is_key_pressed(KEY_SPACE)):
		shield.take_shield_damage(50)
		timer = wait
