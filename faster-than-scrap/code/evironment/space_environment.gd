class_name SpaceEnvironment
extends WorldEnvironment

## Texture rotation speed
@export var rotation_speed : float = 4
## Speed of [member Environment.glow_bloom] chagnes 
@export var bloom_speed : float = 8
## Amplitude of [member Environment.glow_bloom] changes
@export var bloom_amplitude : float = 0.2
## Static [member Environment.glow_bloom] offset 
@export var bloom_offset : float = 0.5

var time : float = 0;

@onready var space_env : Environment = get_environment()

func _process(delta: float) -> void:
	# Texture rotation
	var rotation_amount : float = fmod( delta * rotation_speed * 0.001 , 2 * PI )
	space_env.sky_rotation.y += rotation_amount
	$NebulaLights.transform = $NebulaLights.transform.rotated(Vector3.UP, rotation_amount) 
	# Time calculaton with respect to bloom speed
	time += delta * bloom_speed * 0.1
	time = fmod( time, (2 * PI) )
	# Bloom animation
	var bloom_value = bloom_offset + bloom_amplitude * sin(time)
	space_env.set_glow_bloom(bloom_value)
