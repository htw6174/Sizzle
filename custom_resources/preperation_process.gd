extends Resource
class_name PreperationProcess, "res://sprites/pot.png"

export(String) var display_name
export(Array, Resource) var supported_recipes

func _init(p_display_name = "unnamed process"):
	display_name = p_display_name
	supported_recipes = null

