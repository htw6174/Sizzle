extends ItemSlot

export(Resource) var preperation_process

var active_recipe: Recipe = null
var recipe_component_index: int = 0

var primary_ingredient: Ingredient
var secondary_ingredients: Array

func handle_interaction():
	PlayerHand.notify_interaction(self, pickable_item, pickable_item == null)

func notify_item_taken(item: Ingredient):
	pickable_item = null
	item_sprite.texture = null

func try_insert_item(item: Ingredient) -> bool:
	if active_recipe == null:
		# use ingredient to pick recipe
		for recipe in preperation_process.supported_recipes:
			if item == recipe.primary_ingredient:
				active_recipe = recipe
				primary_ingredient = item
				check_recipe_complete()
				return true
		return false
	else:
		if active_recipe.can_add_ingredient(item, secondary_ingredients):
			secondary_ingredients.append(item)
			check_recipe_complete()
			return true
		else:
			return false

func check_recipe_complete():
	var matching_component_count = 0
	var required_component_count = active_recipe.components.size()
	for component in active_recipe.components:
		if component in secondary_ingredients:
			matching_component_count += 1
	if matching_component_count == required_component_count:
		pickable_item = active_recipe.result_ingredient
		item_sprite.texture = pickable_item.texture
		
		active_recipe = null
		primary_ingredient = null
		secondary_ingredients.clear()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			handle_interaction()
