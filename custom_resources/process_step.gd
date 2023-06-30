@icon("res://sprites/cutting board.png")
extends Node
class_name ProcessStep

@export var ingredients: Array[Ingredient]
@export var time_to_complete: float = 1.0

func get_display_name():
	# TODO: should return node name converted from PascalCase into plain english
	return self.name

func check_requirements(in_ingredients: Array[Ingredient]) -> bool:
	# for every requirement, search in_ingredients and remove if found. return true if all requirements found
	# sort then compare might also work, but comparing Resources or RIDs doesn't seem to be deterministic
	var temp_inputs = in_ingredients.duplicate()
	for ingredient in self.ingredients:
		if temp_inputs.has(ingredient):
			temp_inputs.erase(ingredient)
		else:
			return false
	return true

func check_child_requirements(in_ingredients: Array[Ingredient]) -> ProcessStep:
	for child in self.get_children():
		if child as ProcessStep:
			if child.check_requirements(in_ingredients):
				return child
	return null

func does_step_require_ingredient(in_ingredients: Array, next_ingredient: Ingredient) -> bool:
	# TODO: improve this so it still works if there are duplicate ingredients in the step's requirements
	return (self.ingredients.has(next_ingredient)) and (not in_ingredients.has(next_ingredient))

func does_any_child_require_ingredient(in_ingredients: Array, next_ingredient: Ingredient) -> bool:
	for child in self.get_children():
		if child as ProcessStep:
			if child.does_step_require_ingredient(in_ingredients, next_ingredient):
				return true
	return false

func has_result() -> bool:
	for child in self.get_children():
		if child is ProcessResult:
			return true
	return false

func get_data() -> Ingredient:
	for child in self.get_children():
		if child is ProcessResult:
			return child.ingredient
	return null
