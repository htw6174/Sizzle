extends Resource

class_name Recipe, "res://sprites/chopped veg.png"

export(Resource) var primary_ingredient
export(bool) var is_recipe_ordered
export(Array) var components
export(Resource) var result_ingredient

func _init():
	primary_ingredient = null
	components = null
	result_ingredient = null

