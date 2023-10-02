class_name ItemSlot extends Interactable

@export var tool_type: Cookbook.ToolTypes = Cookbook.ToolTypes.Combine

var held_item: Ingredient
var processing_tool: ProcessingTool

func _ready():
	super()
	processing_tool = Cookbook.get_tool_by_type(tool_type)
	if held_item != null:
		display_name = held_item.display_name
		item_sprite.texture = held_item.texture
	else:
		display_name = "Empty"

func try_insert_item(item: Ingredient) -> bool:
	if held_item == null:
		held_item = item
		display_name = held_item.display_name
		item_sprite.texture = held_item.texture
		item_sprite.modulate = Color(1, 1, 1, 1)
		item_inserted.emit(item)
		return true
	else:
		if check_for_recipe(held_item, item):
			return true
		else:
			return false

func try_reserve_item() -> Ingredient:
	if held_item != null:
		is_item_reserved = true
		display_name = "Empty"
		item_sprite.modulate = Color(1, 1, 1, 0.5)
		item_reserved.emit(held_item)
		return held_item
	else:
		return null

func try_take_item() -> Ingredient:
	if held_item != null:
		var temp_item = held_item
		held_item = null
		display_name = "Empty"
		item_sprite.texture = null
		item_removed.emit(temp_item)
		return temp_item
	else:
		return null

func try_return_item() -> bool:
	if held_item != null:
		is_item_reserved = false
		display_name = held_item.display_name
		item_sprite.modulate = Color(1, 1, 1, 1)
		item_returned.emit(held_item)
		return true
	else:
		return false

static func try_swap_item(slot1: ItemSlot, slot2: ItemSlot) -> bool:
	var item1 = slot1.held_item
	var item2 = slot2.held_item
	if slot1.can_accept_item(item2) and slot2.can_accept_item(item1):
		slot1.held_item = null
		if slot1.try_insert_item(item2):
			slot2.held_item = null
			if slot2.try_insert_item(item1):
				return true
			else:
				# no option now but to keep hold of item2
				print_debug(slot2.display_name, " couldn't accept ", item1.display_name)
				return false
		else:
			return false
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
			held_item = recipe.result
			display_name = held_item.display_name
			item_sprite.texture = held_item.texture
			return true
	return false
