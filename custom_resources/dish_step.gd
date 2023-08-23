@icon("res://sprites/plate empty.png")
extends Node
class_name DishStep

@export var sprite_sheet: Texture2D
@export var components: Array[DishComponent]

func get_display_name():
	# TODO: should return node name converted from PascalCase into plain english
	return self.name

# return true if in_ingredients has at least one of the Ingredients on every required component's option list
# TODO: doesn't account for overlapping ingredients in different option lists
func check_requirements(in_ingredients: Array[Ingredient]) -> bool:
	var temp_inputs = in_ingredients.duplicate()
	# remove each required ingredient from input list, return false if any requirements aren't in input
	for component in components:
		if component.required:
			var any_option_matched = false
			for option in component.options:
				if temp_inputs.has(option.ingredient):
					temp_inputs.erase(option.ingredient)
					any_option_matched = true
					break
			if !any_option_matched:
				return false
	return true

func check_components(in_ingredient: Ingredient) -> DishComponent:
	for component in components:
		if component.ingredient == in_ingredient:
			return component
	return null

func check_child_requirements(in_ingredient: Ingredient) -> DishStep:
	for child in self.get_children():
		if child as DishStep:
			if child.check_requirements(in_ingredient):
				return child
	return null

func accepts_ingredient(in_ingredient: Ingredient) -> bool:
	for component in components:
		if component.accepts_ingredient(in_ingredient):
			return true
	return false

func child_accepting_ingredient(in_ingredient: Ingredient) -> DishStep:
	for child in self.get_children():
		if child as DishStep:
			if child.accepts_ingredient(in_ingredient):
				return child
	return null

func does_any_child_require_ingredient(in_ingredient: Ingredient, next_ingredient: Ingredient) -> bool:
	for child in self.get_children():
		if child as DishStep:
			if child.check_requirements(in_ingredient):
				return true
	return false
