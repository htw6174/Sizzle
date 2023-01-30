extends Resource

class_name Dish, "res://sprites/kitchen.png"

export(String) var display_name
export(Texture) var texture
export(Array) var components

func _init(p_display_name = "unnamed dish"):
	display_name = p_display_name
	components = null
