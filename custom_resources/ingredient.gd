extends Resource
class_name Ingredient, "res://sprites/carrot.png"

export(String) var display_name
export(Texture) var texture setget , get_texture

var fallback_texture = preload("res://sprites/fallback.png")

func _init(p_display_name = "unnamed ingredient", p_texture = null):
	display_name = p_display_name
	texture = p_texture

func get_texture():
	if texture == null:
		return fallback_texture
	else:
		return texture
