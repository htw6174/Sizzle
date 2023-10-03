@icon("res://sprites/carrot.png")
extends Resource
class_name Ingredient

var fallback_texture = preload("res://sprites/fallback.png")
var audio_pickup_fallback = preload("res://audio/handling/pap_pickup.wav")
var audio_drop_fallback = preload("res://audio/handling/pap_drop.wav")

@export var display_name: String
@export var texture: Texture2D:
	get:
		if texture == null:
			return fallback_texture
		else:
			return texture

@export var audio_pickup: AudioStream:
	get:
		if audio_pickup == null:
			return audio_pickup_fallback
		else:
			return audio_pickup

@export var audio_drop: AudioStream:
	get:
		if audio_drop == null:
			return audio_drop_fallback
		else:
			return audio_drop

func _init(p_display_name = "unnamed ingredient", p_texture = null):
	display_name = p_display_name
	texture = p_texture
