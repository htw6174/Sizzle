extends Resource
class_name DishComponent

@export var name: String
@export var required: bool = true
@export var options: Array[DishComponentOption]

func accepts_ingredient(in_ingredient: Ingredient) -> bool:
	for option in options:
		if option.ingredient == in_ingredient:
			return true
	return false

func matching_option(in_ingredient: Ingredient) -> DishComponentOption:
	for option in options:
		if option.ingredient == in_ingredient:
			return option
	return null
