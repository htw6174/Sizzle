extends Resource

class_name Dish, "res://sprites/kitchen.png"

export(String) var display_name
export(bool) var is_ordered
export(SpriteFrames) var texture_frames
export(Array, Resource) var components

func _init(p_display_name = "unnamed dish"):
	display_name = p_display_name
	components = null

func can_add_ingredient(ingredient: Ingredient, added_ingredients: Array) -> bool:
	if ingredient == null:
		return false
	if is_ordered:
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