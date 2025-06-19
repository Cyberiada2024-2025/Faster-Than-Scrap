class_name SoundEmitter

extends AudioStreamPlayer3D

enum StopBehaviour {
	## When [method stop_playing] is called, the audio is immediately stopped.
	STOP_IMMEDIATELY,
	## When [method stop_playing] is called, if audio stream is of type [AudioStreamInteractive],
	## the played audio clip is transitioned to one specified in [member transition_clip_name].
	TRANSITION
}

## Controls whether or not this emmitter allows multiple sounds to be played at the same time.
## If set to false, all [method start_playing] calls
## will be ignored if the emitter is already playing. [br][br]
##
## For more control over the number of sounds played at once, see:
## [member AudioStreamPlayer3D.max_polyphony]
@export var allow_multiple_sounds_at_once: bool = true

## When the sound emitter starts playing the sound, the [member AudioStreamPlayer3D.pitch_scale]
## will be set to a random value between [member min_pitch_scale] and [member max_pitch_scale].
## [br][br]
##
## [b]Note:[/b] For some reason (bug in Godot?), changing pitch scale doesn't work with
## sub-streamable audio streams (such as [AudioStreamInteractive], [AudioStreamPlaylist],
## [AudioStreamSynchronized]).
@export var min_pitch_scale: float = 1

## See: [member min_pitch_scale]
@export var max_pitch_scale: float = 1

## When the sound emitter starts playing the sound, the audio will start playing from point randomly
## chosen between [member min_random_start_offset] and [member max_random_start_offset] (in seconds).
## [br][br]
##
## [b]Note:[/b] Not tested with sub-streamable audio streams (such as [AudioStreamInteractive],
## [AudioStreamPlaylist], [AudioStreamSynchronized]) - may not work, or behave unexpectedly.
@export var min_random_start_offset: float = 0

## See: [member min_random_start_offset]
@export var max_random_start_offset: float = 0

## Specifies behaviour of sound emitter when [method stop_playing] is called.
@export var stop_behaviour: StopBehaviour = StopBehaviour.STOP_IMMEDIATELY

## If [member stop_behaviour] is set to [code]TRANSITION[/code], and the audio stream is of type
## [AudioStreamInteractive], specifies the name of the clip the playback transitions to
## when [method stop_playing] is called. Otherwise, it is ignored.
@export var transition_clip_name: StringName = ""


func _ready():
	# override the base autoplay behaviour, to include random pitch shifting and offset
	if autoplay:
		stop()
		start_playing()


func _can_play() -> bool:
	if playing and not allow_multiple_sounds_at_once:
		return false

	return true


func _set_random_pitch_scale() -> void:
	pitch_scale = randf_range(min_pitch_scale, max_pitch_scale)


## Starts playing the sound, if it's allowed (see [member allow_multiple_sounds_at_once]). [br][br]
##
## [b]Note:[/b] This function accepts a lot of arguments, with default [code]null[/code] values.
## All of them are ignored. The arguments are needed to make Godot recognize it as a legal function
## for connecting signals with different numbers and types of arguments.
## It would be cleaner to accept a variable number of arguments instead of listing
## them here explicitly (similar to [method @GlobalScope.print]),
## but GDScript does not support these yet.
func start_playing(_arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null) -> void:
	if not _can_play():
		return

	_set_random_pitch_scale()
	var random_start_offset = randf_range(min_random_start_offset, max_random_start_offset)
	play(random_start_offset)


## Stops playing the sound. The exact behaviour is controlled by [member stop_behaviour]. [br][br]
##
## [b]Note:[/b] This function accepts a lot of arguments, with default [code]null[/code] values.
## All of them are ignored. The arguments are needed to make Godot recognize it as a legal function
## for connecting signals with different numbers and types of arguments.
## It would be cleaner to accept a variable number of arguments instead of listing
## them here explicitly (similar to [method @GlobalScope.print]),
## but GDScript does not support these yet.
func stop_playing(_arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null) -> void:
	if stop_behaviour == StopBehaviour.TRANSITION:
		var playback = get_stream_playback() as AudioStreamPlaybackInteractive
		playback.switch_to_clip_by_name(transition_clip_name)
	else:
		stop()
