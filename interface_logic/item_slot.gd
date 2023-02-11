extends Interactable

export(PackedScene) var preperation_process_scene
onready var preperation_process: ProcessStep = preperation_process_scene.instance()

func _ready():
	if pickable_item != null:
		display_name = pickable_item.display_name
		item_sprite.texture = pickable_item.texture
	else:
		display_name = "Empty"

func try_insert_item(item: Ingredient) -> bool:
	if pickable_item == null:
		emit_signal("item_inserted", item)
		pickable_item = item
		display_name = pickable_item.display_name
		item_sprite.texture = pickable_item.texture
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
		item_sprite.texture = null
		emit_signal("item_reserved", pickable_item)
		return pickable_item
	else:
		return null

func try_take_item() -> Ingredient:
	if pickable_item != null:
		var temp_item = pickable_item
		pickable_item = null
		display_name = "Empty"
		item_sprite.texture = null
		emit_signal("item_removed", temp_item)
		return temp_item
	else:
		return null

func check_for_recipe(item1: Ingredient, item2: Ingredient) -> bool:
	var recipe = preperation_process.check_child_requirements([item1, item2])
	if recipe != null:
		if recipe.has_result():
			pickable_item = recipe.get_result()
			display_name = pickable_item.display_name
			item_sprite.texture = pickable_item.texture
			return true
	return false
