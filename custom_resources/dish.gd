@icon("res://sprites/kitchen.png")
extends Resource
class_name Dish

@export var display_name: String
@export_multiline var description
@export var is_ordered: bool
# true: should display the texture frames as individual sprites, stacked in recipe order from back to front if is_ordered == true
# false: should display one frame at a time, incrementing upward
@export var stack_frames: bool
@export var texture_frames: SpriteFrames
@export var serving_dish_scene: PackedScene
@export var components: Array[Resource]

func _init(p_display_name = "unnamed dish"):
	display_name = p_display_name
	components = []

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
