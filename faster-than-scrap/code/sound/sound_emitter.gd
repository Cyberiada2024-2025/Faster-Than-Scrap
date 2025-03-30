class_name SoundEmitter

extends AudioStreamPlayer3D

## Controls whether or not this emmitter allows multiple sounds to be played at the same time.
## If set to true, all [method start_playing] calls
## will be ignored if the emitter is the emitter already playing. [br][br]
##
## For more control over the number of sounds played at once, see:
## [member AudioStreamPlayer3D.max_polyphony]
@export var allow_multiple_sounds_at_once: bool = false

## When the sound emitter starts playing the sound, the [member AudioStreamPlayer3D.pitch_scale]
## will be set to a random value between [member min_pitch_scale] and [member max_pitch_scale].
@export var min_pitch_scale: float = 1

## When the sound emitter starts playing the sound, the [member AudioStreamPlayer3D.pitch_scale]
## will be set to a random value between [member min_pitch_scale] and [member max_pitch_scale].
@export var max_pitch_scale: float = 1

## [TODO] doesn't work very well yet
@export var sound_start_delay: float = 0
@export var sound_end_delay: float = 0


func _can_play() -> bool:
	if playing and not allow_multiple_sounds_at_once:
		return false

	return true


func _wait(time: float) -> void:
	await get_tree().create_timer(time).timeout


func _set_random_pitch_scale() -> void:
	pitch_scale = randf_range(min_pitch_scale, max_pitch_scale)


## [TODO] Starts playing the sound. [br][br]
##
## [b]Note:[/b] This function accepts a lot of arguments, with default [code]null[/code] values.
## All of them are ignored. The arguments are needed to make Godot recognize it as a legal function
## for connecting signals with different numbers and types of arguments.
## It would be cleaner to accept a variable number of arguments instead of listing
## them here explicitly (similar to [method @GlobalScope.print]),
## but GDScript does not support these yet.
func start_playing(_arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null) -> void:
	await _wait(sound_start_delay)

	if not _can_play():
		return

	_set_random_pitch_scale()
	play()


## [TODO] Stops playing the sound. [br][br]
##
## [b]Note:[/b] This function accepts a lot of arguments, with default [code]null[/code] values.
## All of them are ignored. The arguments are needed to make Godot recognize it as a legal function
## for connecting signals with different numbers and types of arguments.
## It would be cleaner to accept a variable number of arguments instead of listing
## them here explicitly (similar to [method @GlobalScope.print]),
## but GDScript does not support these yet.
func stop_playing(_arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null) -> void:
	await _wait(sound_end_delay)

	stop()
