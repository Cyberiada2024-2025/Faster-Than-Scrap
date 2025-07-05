class_name CutsceneSoundController
extends Node

@export var panel_show_start_sound_emitters: Dictionary[ColorRect, SoundEmitterGlobal]
@export var panel_show_end_sound_emitters: Dictionary[ColorRect, SoundEmitterGlobal]
@export var comic: ComicSlide


func _ready() -> void:
	comic.comic_panel_show_start.connect(on_comic_panel_show_start)
	comic.comic_panel_show_end.connect(on_comic_panel_show_end)


func on_comic_panel_show_start(color_rect: ColorRect) -> void:
	if panel_show_start_sound_emitters.get(color_rect) != null:
		panel_show_start_sound_emitters[color_rect].start_playing()


func on_comic_panel_show_end(color_rect: ColorRect) -> void:
	if panel_show_end_sound_emitters.get(color_rect) != null:
		panel_show_end_sound_emitters[color_rect].start_playing()
