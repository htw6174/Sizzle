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

func can_add_ingredient(ingredient: Ingredient, added_ingredients: Array) -> bool:
	if is_recipe_ordered:
		var next_ingredient_index = added_ingredients.size()
		if ingredient == self.components[next_ingredient_index]:
			return true
		else:
			return false
	else:
		# subtract added_ingredients from components
		var remaining_ingredients = components.duplicate()
		for added_ingredient in added_ingredients:
			if added_ingredient in remaining_ingredients:
				remaining_ingredients.erase(added_ingredient)
		
		if ingredient in remaining_ingredients:
			return true
		else:
			return false
