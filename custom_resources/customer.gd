extends Resource
class_name Customer

@export var texture: Texture2D
@export var dialogue: Dialogue
@export var loves: Array[Ingredient]
@export var hates: Array[Ingredient]

func rate_dish(ingredients: Array[Ingredient]) -> int:
	var rating = 0
	for ingredient in ingredients:
		if loves.has(ingredient): rating += 1
		if hates.has(ingredient): rating -= 2
	return rating
