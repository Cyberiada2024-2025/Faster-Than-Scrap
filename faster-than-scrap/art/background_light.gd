extends Sprite2D
var fixed_global_position
var time: float = 0
var red: float = 0

func _ready():
	fixed_global_position = global_position

func _process(delta):
	global_position = fixed_global_position
	time = time + delta
	time = fmod(time, 2 * PI)
	red = 0.7 + 0.15 * sin(time)
	self_modulate.r = red 
