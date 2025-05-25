extends Sprite2D

## Amplitude of [member Sprite2D.self_modulate.r] changes (best bept around 0 - 0.2)
@export var red_modulation: float = 0
## Amplitude of [member Sprite2D.self_modulate.g] changes (best bept around 0 - 0.2)
@export var green_modulation: float = 0
## Amplitude of [member Sprite2D.self_modulate.b] changes (best bept around 0 - 0.2)
@export var blue_modulation: float = 0

var fixed_global_position
var time: float = 0
var base_modulate_color: Color = Color(0,0,0,0)

func _ready():
	fixed_global_position = global_position
	base_modulate_color = self_modulate

func _process(delta):
	global_position = fixed_global_position
	time = time + delta
	time = fmod(time, 2 * PI)
	self_modulate.r = base_modulate_color.r + red_modulation * sin(time)
	self_modulate.g = base_modulate_color.g + green_modulation * sin(time)
	self_modulate.b = base_modulate_color.b + blue_modulation * sin(time)
