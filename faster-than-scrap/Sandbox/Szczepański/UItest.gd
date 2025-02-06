extends Node

@export var ship: Ship
@export var energy_bar: ResourceBar

var timer: float
var wait: float = 0.2

var sizes = [100, 200, 500, 1000, 2000, 4000, 6000]
var index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if(timer <= 0 && Input.is_key_pressed(KEY_SPACE)):
		ship.use_energy(40)
		timer = wait
	elif(timer <= 0 && Input.is_key_pressed(KEY_E)):
		index = (index + 1) % sizes.size()
		energy_bar._on_max_change(sizes[index])
		ship.use_energy(-(sizes[index] - ship.energy))
		timer = wait
