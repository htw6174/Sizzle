extends Interactable

@export var tool_type: Cookbook.ToolTypes = Cookbook.ToolTypes.Combine

var processing_tool: ProcessingTool

func _ready():
	super()
	processing_tool = Cookbook.get_tool_by_type(tool_type)
	if pickable_item != null:
		display_name = pickable_item.display_name
		item_sprite.texture = pickable_item.texture
	else:
		display_name = "Empty"

func try_insert_item(item: Ingredient) -> bool:
	if pickable_item == null:
		pickable_item = item
		display_name = pickable_item.display_name
		item_sprite.texture = pickable_item.texture
		item_sprite.modulate = Color(1, 1, 1, 1)
		item_inserted.emit(item)
		return true
	else:
		if check_for_recipe(pickable_item, item):
			return true
		else:
			return false

func try_reserve_item() -> Ingredient:
	if pickable_item != null:
		is_item_reserved = true
		display_name = "Empty"
		item_sprite.modulate = Color(1, 1, 1, 0.5)
		item_reserved.emit(pickable_item)
		return pickable_item
	else:
		return null

func try_take_item() -> Ingredient:
	if pickable_item != null:
		var temp_item = pickable_item
		pickable_item = null
		display_name = "Empty"
		item_sprite.texture = null
		item_removed.emit(temp_item)
		return temp_item
	else:
		return null

func try_return_item() -> bool:
	if pickable_item != null:
		is_item_reserved = false
		display_name = pickable_item.display_name
		item_sprite.modulate = Color(1, 1, 1, 1)
		item_returned.emit(pickable_item)
		return true
	else:
		return false

func check_for_recipe(item1: Ingredient, item2: Ingredient) -> bool:
	var recipes = Cookbook.get_combos(processing_tool, item1, item2)
	if recipes.size() > 1:
		# TODO: present options
		pass
	elif recipes.size() == 1:
		var recipe = recipes[0]
		if recipe.has_result():
			pickable_item = recipe.result
			display_name = pickable_item.display_name
			item_sprite.texture = pickable_item.texture
			return true
	return false
