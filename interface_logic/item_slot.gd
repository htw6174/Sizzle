extends Interactable

export(PackedScene) var preperation_process_scene
onready var preperation_process: ProcessStep = preperation_process_scene.instance()

func _ready():
	if pickable_item != null:
		display_name = pickable_item.display_name
		item_sprite.texture = pickable_item.texture
	else:
		display_name = "Empty"

func handle_interaction():
	PlayerHand.notify_interaction(self, pickable_item, true)

func notify_item_taken(item: Ingredient):
	pickable_item = null
	display_name = "Empty"
	item_sprite.texture = null

func try_insert_item(item: Ingredient) -> bool:
	if pickable_item == null:
		pickable_item = item
		display_name = pickable_item.display_name
		item_sprite.texture = pickable_item.texture
		return true
	else:
		if check_for_recipe(pickable_item, item):
			return true
		else:
			return false

func check_for_recipe(item1: Ingredient, item2: Ingredient) -> bool:
	var recipe = preperation_process.check_child_requirements([item1, item2])
	if recipe != null:
		if recipe.has_result():
			pickable_item = recipe.get_result()
			display_name = pickable_item.display_name
			item_sprite.texture = pickable_item.texture
			return true
	return false
