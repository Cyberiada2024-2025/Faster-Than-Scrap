class_name Shield

extends Node3D

@export var animator: AnimationPlayer
@export var audio_player: AudioStreamPlayer3D
@export var sound_apply: AudioStream
@export var sound_break: AudioStream
@export var sound_hit: AudioStream
@export var collider: CollisionShape3D

var on = false

var anim_close = "Close"
var anim_hit = "Hit";

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func turn_on_off() -> void:
	print(on)
	if(on):
		on = false
		collider.disabled = true
		animator.play_backwards(anim_close)
		audio_player.stream = sound_break
		audio_player.pitch_scale = randf_range(0.9, 1.1)
		audio_player.play()
	else:
		on = true
		collider.disabled = false
		animator.play(anim_close)
		audio_player.stream = sound_apply
		audio_player.pitch_scale = randf_range(0.9, 1.1)
		audio_player.play()

func take_damage() -> void:
	animator.play(anim_hit)
	audio_player.stream = sound_hit
	audio_player.pitch_scale = randf_range(0.8, 1.2)
	audio_player.play()
