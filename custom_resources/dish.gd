extends Resource

class_name Dish, "res://sprites/kitchen.png"

export(String) var display_name
export(String, MULTILINE) var description
export(bool) var is_ordered
# true: should display the texture frames as individual sprites, stacked in recipe order from back to front if is_ordered == true
# false: should display one frame at a time, incrementing upward
export(bool) var stack_frames
export(SpriteFrames) var texture_frames
export(PackedScene) var serving_dish_scene
export(Array, Resource) var components

func _init(p_display_name = "unnamed dish"):
	display_name = p_display_name
	components = null

class DishInProgress:
	var dish: Dish
	var added_ingredients: Array
	var remaining_ingredients: Array
	
	func _init(base_dish: Dish):
		dish = base_dish
		added_ingredients = []
		remaining_ingredients = base_dish.components.duplicate()
	
	func can_add_ingredient(ingredient: Ingredient) -> bool:
		if ingredient == null:
			return false
		if dish.is_ordered:
			return ingredient == remaining_ingredients[0]
		else:
			return ingredient in remaining_ingredients
	
	func add_ingredient(ingredient: Ingredient):
		if can_add_ingredient(ingredient):
			added_ingredients.append(ingredient)
			remaining_ingredients.erase(ingredient)
	
	func is_finished() -> bool:
		return remaining_ingredients.size() == 0
