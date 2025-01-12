extends WorldEnvironment

@export var rotation_speed : float = 4
@export var bloom_speed : float = 8
@export var bloom_amplitude : float = 0.2
@export var bloom_offset : float = 0.5

var time : float = 0;

@onready var space_env : Environment = get_environment()

func _process(delta: float) -> void:
	# Texture rotation
	space_env.sky_rotation.y += fmod( delta * rotation_speed * 0.001 , 2 * PI )
	
	# Time calculaton with respect to bloom speed
	time += delta * bloom_speed * 0.1
	time = fmod( time, (2 * PI) )
	
	# Bloom animation
	var bloom_value = bloom_offset + bloom_amplitude * sin(time)
	space_env.set_glow_bloom(bloom_value)
