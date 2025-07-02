extends Node

@export var click_sound_emitter: SoundEmitterGlobal


func play_click_sound():
	click_sound_emitter.start_playing()
