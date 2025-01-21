extends Node

@export var shield: Shield

var wait = 0.5
var timer = 0.0

func _process(delta: float) -> void:
	timer -= delta
	if(timer <= 0 && Input.is_key_pressed(KEY_W)):
		shield.turn_on_off()
		timer = wait
	elif(timer <= 0 && Input.is_key_pressed(KEY_SPACE)):
		shield.take_damage(50)
		timer = wait
