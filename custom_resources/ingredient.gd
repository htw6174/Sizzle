extends Resource
class_name Ingredient, "res://sprites/carrot.png"

export(String) var display_name
export(Texture) var texture setget , get_texture
export(AudioStream) var interact_audio_1 setget , get_interact_audio_1
export(AudioStream) var interact_audio_2 setget , get_interact_audio_2

var fallback_texture = preload("res://sprites/fallback.png")
var fallback_interact_audio_1 = preload("res://audio/sound_fx_-_pick_up.mp3")
var fallback_interact_audio_2 = preload("res://audio/sound_fx_-_drop.mp3")

func _init(p_display_name = "unnamed ingredient", p_texture = null):
	display_name = p_display_name
	texture = p_texture

func get_texture():
	if texture == null:
		return fallback_texture
	else:
		return texture

func get_interact_audio_1():
	if interact_audio_1 == null:
		return fallback_interact_audio_1
	else:
		return interact_audio_1

func get_interact_audio_2():
	if interact_audio_2 == null:
		return fallback_interact_audio_2
	else:
		return interact_audio_2
